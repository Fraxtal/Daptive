using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Runtime.Remoting.Messaging;
using System.Security;
using System.Security.Permissions;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.CSharp;

namespace CodeRunner
{
    // Run code in isolated AppDomain
    [System.Security.SecuritySafeCritical]
    public class SandboxProxy : MarshalByRefObject
    {
        public ExecutionResult Execute(byte[] compiledBytes, string[] testCases)
        {
            try
            {
                // load compiled code
                Assembly assembly = Assembly.Load(compiledBytes);

                // searching for main fucntion under any class
                MethodInfo mainMethod = null;
                foreach (Type type in assembly.GetTypes())
                {
                    // Search for static method named Main, including public and non public
                    mainMethod = type.GetMethod("Main", BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Static);
                    if (mainMethod != null) break; // break when found
                }

                if (mainMethod == null)
                    return new ExecutionResult { IsError = true, ErrorMessage = "Error: Cannot find the starting point. Ensure you have the main function in your code." };

                // Execution
                Type consoleType = assembly.GetType("SandboxConsole");
                FieldInfo inputField = consoleType.GetField("Input", BindingFlags.Public | BindingFlags.Static);
                FieldInfo outputField = consoleType.GetField("Output", BindingFlags.Public | BindingFlags.Static);
                MethodInfo clearMethod = consoleType.GetMethod("Clear", BindingFlags.Public | BindingFlags.Static);

                string[] results = new string[testCases.Length];

                for (int i = 0; i < testCases.Length; i++)
                {
                    // clear previous output
                    clearMethod.Invoke(null, null);

                    // input testcase
                    string rawinput = testCases[i] ?? "";
                    string actualInput = System.Text.RegularExpressions.Regex.Unescape(rawinput);
                    inputField.SetValue(null, new StringReader(actualInput));

                    // execute student's main function
                    if (mainMethod.GetParameters().Length > 0)
                        mainMethod.Invoke(null, new object[] { new string[0] });
                    else
                        mainMethod.Invoke(null, null);

                    // extract current output and save
                    StringWriter sw = (StringWriter)outputField.GetValue(null);
                    results[i] = sw.ToString();
                }

                return new ExecutionResult { IsError = false, Outputs = results };
            }
            catch (TargetInvocationException ex)
            {
                return new ExecutionResult { IsError = true, ErrorMessage = "Runtime Error: " + ex.InnerException?.Message };
            }
            catch (SecurityException ex)
            {
                return new ExecutionResult { IsError = true, ErrorMessage = "Security Blocked: Your code attempted to perform a prohibited operation.\nDetails: " + ex.Message };
            }
            catch (Exception ex)
            {
                return new ExecutionResult { IsError = true, ErrorMessage = "Sandbox Exception: " + ex.InnerException?.Message ?? ex.Message };
            }
        }
    }

    // Compiler and Runner
    public class CSharpRunner
    {
        public static ExecutionResult CompileAndRun(string userCode, int timeoutMilliseconds = 3000)
        {
            return CompileAndRun(userCode, new string[] { "" }, timeoutMilliseconds);
        }
        public static ExecutionResult CompileAndRun(string userCode, string[] testCases, int timeoutMilliseconds = 3000)
        {
            // make a virtual console(Sandbox Console) and attach it after the student's code
            string injectedCode = @"
            using System;
            using System.Collections;
            using System.Collections.Generic;
            using System.Linq;
            using System.Text;
            using System.Text.RegularExpressions;
            using System.Numerics;

            using Console = SandboxConsole;

            public static class SandboxConsole
            {
                public static System.IO.StringWriter Output = new System.IO.StringWriter();
                public static System.IO.StringReader Input;
                public static string ReadLine() { return Input != null ? Input.ReadLine() : null; }
                public static void Clear() {Output.GetStringBuilder().Clear(); }
                public static void WriteLine(object obj) { Output.WriteLine(obj); }
                public static void WriteLine(string obj) { Output.WriteLine(obj); }
                public static void WriteLine() { Output.WriteLine(); }
                public static void Write(object obj) { Output.Write(obj); }
                public static void Write(string obj) { Output.Write(obj); }
                public static int Read() { return Input != null ? Input.Read() : -1; }
                public static string ReadToEnd() { return Input != null ? Input.ReadToEnd() : null; }
            }";
            string finalCode = injectedCode + "\n#line 1\n" + userCode;

            // setup compiler
            CSharpCodeProvider provider = new CSharpCodeProvider();
            CompilerParameters parameters = new CompilerParameters();

            string tempAssemblyPath = Path.Combine(Path.GetTempPath(), Guid.NewGuid().ToString() + ".dll");
            parameters.OutputAssembly = tempAssemblyPath;
            parameters.GenerateExecutable = false;
            parameters.ReferencedAssemblies.Add("System.dll");
            parameters.ReferencedAssemblies.Add("System.Core.dll");

            // compile code
            CompilerResults results = provider.CompileAssemblyFromSource(parameters, finalCode);

            if (results.Errors.HasErrors)
            {
                string errors = "";
                foreach (CompilerError error in results.Errors)
                {
                    errors += $"Compile Error - line {error.Line}: {error.ErrorText}\n";
                }
                return new ExecutionResult { IsError = true, ErrorMessage = errors };
            }

            // read the code in bytes and clear temporary file
            byte[] compiledBytes = File.ReadAllBytes(tempAssemblyPath);
            File.Delete(tempAssemblyPath);

            //setup system permission for the sandbox
            PermissionSet restrictedPermissions = new PermissionSet(PermissionState.None);

            // setup permission to execute and load byte[]
            restrictedPermissions.AddPermission(new SecurityPermission(SecurityPermissionFlag.Execution | SecurityPermissionFlag.ControlEvidence | SecurityPermissionFlag.SerializationFormatter));

            string binFolderPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "bin");
            if (Directory.Exists(binFolderPath))
            {
                restrictedPermissions.AddPermission(new FileIOPermission(FileIOPermissionAccess.Read | FileIOPermissionAccess.PathDiscovery, binFolderPath));
            }

            AppDomainSetup setup = new AppDomainSetup
            {
                ApplicationBase = AppDomain.CurrentDomain.BaseDirectory,
                PrivateBinPath = "bin"
            };

            //Creating sandbox
            AppDomain sandboxDomain = AppDomain.CreateDomain("Sandbox", null, setup, restrictedPermissions, null);

            ExecutionResult executionOutput = null;
            Exception threadException = null;

            //Use multi thread to avoid infinite loop
            Thread workerThread = new Thread(() =>
            {
                try
                {
                    Type proxyType = typeof(SandboxProxy);
                    SandboxProxy runner = (SandboxProxy)sandboxDomain.CreateInstanceAndUnwrap(
                        proxyType.Assembly.FullName,
                        proxyType.FullName);

                    executionOutput = runner.Execute(compiledBytes, testCases);
                }
                catch (ThreadAbortException)
                {
                    Thread.ResetAbort();
                }
                catch (Exception ex)
                {
                    threadException = ex;
                }
            });

            workerThread.Start();
            bool didFinishInTime = workerThread.Join(TimeSpan.FromMilliseconds(timeoutMilliseconds));
            AppDomain.Unload(sandboxDomain); // unload to clear up memory

            if (!didFinishInTime)
            {
                workerThread.Abort();
                return new ExecutionResult { IsError = true, ErrorMessage = "Execution timeout: Your code execution exceeds the time limit (3 seconds).Is there an infinite loop？" };
            }

            if (threadException != null)
            {
                return new ExecutionResult { IsError = true, ErrorMessage = $"Proxy Error: {threadException.Message}" };
            }

            return executionOutput;
        }
    }
}
