package Client;
import java.io.File;
import java.io.IOException;
import java.net.Socket;

import SocketConnection.QueryCommand;
import org.apache.commons.io.monitor.FileAlterationListenerAdaptor;

import javax.swing.*;

public class FileListener extends FileAlterationListenerAdaptor {

        @Override
        public void onFileChange(File file) {
            String fileName = file.getName();
            String fileExtention = fileName.substring(fileName.lastIndexOf(".") + 1).trim();
            String filepath = GenieUI.FileMonitorPATH + "\\" + fileName;
            QueryCommand type = QueryCommand.getCommandName(fileName);
            System.out.println(type);
            if (type!=null){

                if ((type==QueryCommand.FILE && fileExtention.equals("pdf"))
                        || (type!=QueryCommand.FILE && fileExtention.equals("html"))
                        || (type!=QueryCommand.FILE && fileExtention.equals("xls")))
                {
                    GenieUI.COMMAND = type;
                    GenieUI.FILE_EXTENSION = fileExtention;
                    System.out.println("The Content of File "+filepath+" Change!");
                }
                else{
                    JPanel panel1 = new JPanel();
                    JOptionPane.showMessageDialog(panel1,
                            "Invalid files in the current selection.\n" +
                                    "Please upload the file with '.html', '.xls' extension for uploading the Genie data\n" +
                                    "or with '.pdf' extension named with 'File' for uploading reports to users.",
                            "Warn", JOptionPane.WARNING_MESSAGE);
                    GenieUI.COMMAND = null;
                    GenieUI.FILE_EXTENSION = null;
                    System.out.println("Upload Failed");
                }

            }else{
                JPanel panel2 = new JPanel();
                JOptionPane.showMessageDialog(panel2,
                        "Invalid files in the current selection.\n" +
                                "Please upload the file named with one of the QueryCommand:\n"+
                                "'Appointment', 'Patient', 'Doctor', 'Hospital', 'Pathology', 'Radiology','Resource', or 'File'",
                        "Warn", JOptionPane.WARNING_MESSAGE);
                GenieUI.COMMAND = null;
                //pathTextArea.setText("");
                GenieUI.FILE_EXTENSION = null;
                System.out.println("Upload Failed");
            }
            GenieUI.FILE_UPLOAD_PATH = filepath;
            if (GenieUI.COMMAND != null) {
                System.out.println("Send Update");
                try {
                    Socket clientSocket = GenieUI.initSSLSocket();
//                    Socket clientSocket = new Socket(IP, PORT);
                    TCPClient tcpClient = new TCPClient(clientSocket);
                    Thread tcpThread = new Thread(tcpClient);
                    tcpThread.start();
                } catch (IOException e1) {
                    e1.printStackTrace();
                }
            }
            else{
                JPanel panel4 = new JPanel();
                JOptionPane.showMessageDialog(panel4,
                        "Please upload the correct file!",
                        "Warn", JOptionPane.WARNING_MESSAGE);
                System.out.println("Please upload the correct file!");
            }
        }

        @Override
        public void onFileCreate(File file) {
            String fileName = file.getName();
            String fileExtention = fileName.substring(fileName.lastIndexOf(".") + 1).trim();
            String filepath = GenieUI.FileMonitorPATH + "\\" + fileName;
            QueryCommand type = QueryCommand.getCommandName(fileName);
            System.out.println(type);
            if (type!=null){

                if ((type==QueryCommand.FILE && fileExtention.equals("pdf"))
                        || (type!=QueryCommand.FILE && fileExtention.equals("html"))
                        || (type!=QueryCommand.FILE && fileExtention.equals("xls")))
                {
                    GenieUI.COMMAND = type;
                    GenieUI.FILE_EXTENSION = fileExtention;
                    System.out.println("New File " + filepath + "has been synchronized!");
                }
                else{
                    JPanel panel1 = new JPanel();
                    JOptionPane.showMessageDialog(panel1,
                            "Invalid files in the current selection.\n" +
                                    "Please upload the file with '.html', '.xls' extension for uploading the Genie data\n" +
                                    "or with '.pdf' extension named with 'File' for uploading reports to users.",
                            "Warn", JOptionPane.WARNING_MESSAGE);
                    GenieUI.COMMAND = null;
                    //pathTextArea.setText("");
                    GenieUI.FILE_EXTENSION = null;
                    System.out.println("Upload Failed");
                }

            }else{
                JPanel panel2 = new JPanel();
                JOptionPane.showMessageDialog(panel2,
                        "Invalid files in the current selection.\n" +
                                "Please upload the file named with one of the QueryCommand:\n"+
                                "'Appointment', 'Patient', 'Doctor', 'Hospital', 'Pathology', 'Radiology','Resource', or 'File'",
                        "Warn", JOptionPane.WARNING_MESSAGE);
                GenieUI.COMMAND = null;
                GenieUI.FILE_EXTENSION = null;
                System.out.println("Upload Failed");
            }
            GenieUI.FILE_UPLOAD_PATH = filepath;
            if (GenieUI.COMMAND != null) {
                System.out.println("Send Update");
                try {
                    Socket clientSocket = GenieUI.initSSLSocket();
                    TCPClient tcpClient = new TCPClient(clientSocket);
                    Thread tcpThread = new Thread(tcpClient);
                    tcpThread.start();
                } catch (IOException e1) {
                    e1.printStackTrace();
                }
            }
            else{
                JPanel panel4 = new JPanel();
                JOptionPane.showMessageDialog(panel4,
                        "Please upload the correct file!",
                        "Warn", JOptionPane.WARNING_MESSAGE);
                System.out.println("Please upload the correct file!");
            }
        }

        @Override
        public void onFileDelete(File file) {
            String filepath = GenieUI.FileMonitorPATH + "\\" + file.getName();
            System.out.println("File " + filepath + " Delete!");
            //System.out.println("Please upload a new " + file.getName());
        }

}
