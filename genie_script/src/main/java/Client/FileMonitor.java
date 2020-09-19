package Client;
import java.util.concurrent.TimeUnit;
import org.apache.commons.io.monitor.FileAlterationMonitor;
import org.apache.commons.io.monitor.FileAlterationObserver;
public class FileMonitor {

        private static void FileListenerTest(String FilePATH) throws Exception{
            String filePath = FilePATH;// monitor path
            long interval = TimeUnit.MILLISECONDS.toMillis(100);// set time interval 0.1sec
            FileAlterationObserver observer = new FileAlterationObserver(filePath);
            observer.addListener(new FileListener());//new file listener
            FileAlterationMonitor monitor = new FileAlterationMonitor(interval, observer);
            monitor.start();//开始监听
        }

        public static void MonitorStart(String FilePATH) {
            new Thread(new Runnable() {

                @Override
                public void run() {
                    try {
                        System.out.println("Start Listening");
                        FileListenerTest(FilePATH);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }).start();
        }
}

