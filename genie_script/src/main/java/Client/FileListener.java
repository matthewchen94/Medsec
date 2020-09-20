package Client;
import java.io.File;
import org.apache.commons.io.monitor.FileAlterationListenerAdaptor;
public class FileListener extends FileAlterationListenerAdaptor {

        @Override
        public void onFileChange(File file) {
            System.out.println("The Content of File "+file.getName()+" Change!");
        }

        @Override
        public void onFileCreate(File file) {
            System.out.println("New File " + file.getName());
        }

        @Override
        public void onFileDelete(File file) {
            System.out.println("File " + file.getName() + " Delete!");
        }

}

