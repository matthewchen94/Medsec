package Client;

import SocketConnection.QueryCommand;

import javax.net.ssl.KeyManagerFactory;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManagerFactory;
import javax.swing.*;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.text.DefaultCaret;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.net.Socket;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.KeyStore;

public class GenieUI {
    private static int PORT = 11111;
    private static String IP = "13.58.243.191";
    public static String FileMonitorPATH="Please choose a directory as a Genie file";
    public static boolean monitorThread = false;//update 20/09/2020
    private static long prevTime;
    // 30 mins delay for update
    private static long DELAY_UPDATE = 12 * 60 * 60 * 1000;

    private static final Path PATH = Paths.get
            ("src/main/resources/").toAbsolutePath();
    //private static final String GENIE_DB_NAME = "TestData/user.json";
    private static final String CLIENT_KEY_STORE_PASSWORD = "client";
    private static final String CLIENT_TRUST_KEY_STORE_PASSWORD = "client";
    private static final String CLIENT_KEY_PATH = "/client_ks.jks";
    private static final String TRUST_SERVER_KEY_PATH = "/serverTrust_ks.jks";

    public static QueryCommand COMMAND = null;
    public static String FILE_UPLOAD_PATH = "";
    public static String FILE_EXTENSION = null;
    public static String PATIENT_FILE_UPLOAD_PATH = "";
    public static String APPOINTMENT_FILE_UPLOAD_PATH = "";


    private JPanel panelMain;
    private JTextField ipField;
    private JTextField portField;
    private JTextField monitorPath; //update 20/09/2020
    private JButton sendUpdateButton;
    private JButton updateIPButton;
    private JButton updateMonitorButton;   //update 20/09/2020
    private JTextArea consoleTextArea;
    private JScrollPane consoleScrollPane;

    // update 20/09/2020
    private JButton choosePath;
    private JTextField pdfPath;
    private JButton updatePdfButton;
    //    waiting to be finished in Sprint2
    private JTextField resource_UserID;
    private JTextField resource_Title;
    private JComboBox selectPurpose;
    private JTextArea resource_Messages;
    private JScrollPane messageScrollPane;

    public GenieUI() {
        // Set print stream to output textarea
        PrintStream printStream = new PrintStream(new ConsoleOutputStream(consoleTextArea));
        System.setOut(printStream);
        System.setErr(printStream);

        // Allow for scrolling
        DefaultCaret caret = (DefaultCaret)consoleTextArea.getCaret();
        caret.setUpdatePolicy(DefaultCaret.ALWAYS_UPDATE);

        // Default set ip and port
        ipField.setText(IP);
        portField.setText(String.valueOf(PORT));
        pdfPath.setText(FILE_UPLOAD_PATH);
        monitorPath.setText(FileMonitorPATH);     //update 20/09/2020

        // Update IP button
        updateIPButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                IP = ipField.getText();
                PORT = Integer.parseInt(portField.getText());
                System.out.println("Server address has been set to : " + IP +":"+ PORT);
            }
        });

        //Choose directory button
        choosePath.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                JFileChooser jfc = new JFileChooser();
                //
                jfc.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
                //
                jfc.setCurrentDirectory(new File("."));
                jfc.setMultiSelectionEnabled(false);
                jfc.showDialog(panelMain,"Save");
                File file = jfc.getSelectedFile();
                FileMonitorPATH = file.getAbsolutePath();
                monitorPath.setText(FileMonitorPATH);
            }
        });

        //Update monitor file path button  20/09/2020
        updateMonitorButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                if (GenieUI.monitorThread == false){
                    GenieUI.monitorThread = true;
//                    FileMonitorPATH = monitorPath.getText();
                    System.out.println("Location of files from GENIE has been set to : " + FileMonitorPATH);
                    FileMonitor monitor = new FileMonitor();
                    monitor.MonitorStart(FileMonitorPATH);
                }else{
                    JPanel monitorPanel = new JPanel();
                    JOptionPane.showMessageDialog(monitorPanel,
                            "Please close this application and open a new one to reset the file location!",
                            "Warn", JOptionPane.WARNING_MESSAGE);
                }

            }
        });
        // Update Patient File Path button
        updatePdfButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                JFileChooser jfc = new JFileChooser();
                jfc.setCurrentDirectory(new File("."));
                jfc.setFileFilter(new FileNameExtensionFilter("PDF file",".pdf"));

                // Display the file dialog
                jfc.showSaveDialog(panelMain);
                try {
                    // Use File class to obtain the file from selection
                    File file = jfc.getSelectedFile();//
                    System.out.println("Upload "+ file.getName() +" File");
                    String fileName = file.getName();
                    String fileExtention = fileName.substring(fileName.lastIndexOf(".") + 1).trim();
                    //Determine the command type
                    System.out.println("fileExtention "+fileExtention);
                    QueryCommand type = QueryCommand.getCommandName(file.getName());
                    System.out.println(type);
                    if (type==QueryCommand.FILE){

                        if ((type==QueryCommand.FILE && fileExtention.equals("pdf")))
                        {
                            COMMAND = type;
                            pdfPath.setText(file.getAbsolutePath());
                            FILE_EXTENSION = fileExtention;
                        }
                        else{
                            JPanel panel1 = new JPanel();
                            JOptionPane.showMessageDialog(panel1,
                                    "Invalid files in the current selection.\n" +
                                            "Please upload the file with '.pdf' extension named with 'File' for uploading reports to users.\n",
                                    "Warn", JOptionPane.WARNING_MESSAGE);
                            COMMAND = null;
                            pdfPath.setText("");
                            FILE_EXTENSION = null;
                            System.out.println("Upload Failed");
                        }

                    }else{
                        JPanel panel2 = new JPanel();
                        JOptionPane.showMessageDialog(panel2,
                                "Invalid files in the current selection.\n" +
                                        "Please upload the file named with one of the QueryCommand:\n"+
                                        "'File'",
                                "Warn", JOptionPane.WARNING_MESSAGE);
                        COMMAND = null;
                        pdfPath.setText("");
                        FILE_EXTENSION = null;
                        System.out.println("Upload Failed");
                    }
                } catch (Exception e2) {
                    JPanel panel3 = new JPanel();
                    JOptionPane.showMessageDialog(panel3,
                            "There are no files in the current selection.",
                            "Warn", JOptionPane.WARNING_MESSAGE);
                    COMMAND = null;
                    pdfPath.setText("");
                    FILE_EXTENSION = null;
                    System.out.println("Upload Failed");
                }
                FILE_UPLOAD_PATH = pdfPath.getText();
                System.out.println("Command has been set to : " + COMMAND);
                System.out.println("Path has been set to : " + FILE_UPLOAD_PATH);
            }
        });

        // Create new socket and send update
        sendUpdateButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                if (COMMAND != null) {
                    System.out.println("Send Update");
                    try {
                        Socket clientSocket = initSSLSocket();
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
        });
    }

    /**
     * Instantiate GENIE UI
     * @param args
     * @throws IOException
     * @throws InterruptedException
     */
    public static void main(String[] args) throws IOException, InterruptedException {
        // Init UI
        JFrame frame = new JFrame("Genie Script Application");
        frame.setContentPane(new GenieUI().panelMain);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.pack();
        frame.setVisible(true);
        frame.setSize(1066, 500);


        System.out.println("Client Scheduled Script Running");
    }

    public static Socket initSSLSocket() {
        try{
            KeyStore ks = KeyStore.getInstance("JKS");
            ks.load(new FileInputStream(PATH + CLIENT_KEY_PATH), CLIENT_KEY_STORE_PASSWORD.toCharArray());
            KeyManagerFactory kmf = KeyManagerFactory.getInstance("SunX509");
            kmf.init(ks, CLIENT_KEY_STORE_PASSWORD.toCharArray());

            KeyStore tks = KeyStore.getInstance("JKS");
            tks.load(new FileInputStream(PATH + TRUST_SERVER_KEY_PATH), CLIENT_TRUST_KEY_STORE_PASSWORD.toCharArray());
            TrustManagerFactory tmf = TrustManagerFactory.getInstance("SunX509");
            tmf.init(tks);

            SSLContext context = SSLContext.getInstance("SSL");

            context.init(kmf.getKeyManagers(), tmf.getTrustManagers(), null);

            Socket sslSocket = context.getSocketFactory().createSocket(IP, PORT);

            return sslSocket;
        } catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }
}