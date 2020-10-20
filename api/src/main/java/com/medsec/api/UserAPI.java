//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.medsec.api;

import com.medsec.entity.Callum;
import com.medsec.entity.ChangePasswordRequestTemplate;
import com.medsec.entity.User;
import com.medsec.util.ArgumentException;
import com.medsec.util.AuthenticationException;
import com.medsec.util.Database;
import com.medsec.util.DefaultRespondEntity;
import java.time.LocalDate;
import java.util.Date;
import java.util.Properties;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMessage.RecipientType;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;

@Path("/")
public class UserAPI {
    public UserAPI() {
    }

    @POST
    @Path("user/activate")
    @Consumes({"application/json"})
    @Produces({"application/json"})
    public Response activateUser(User requestUser) {
        try {
            User user = this.verifyUserInformation(requestUser);
            user.password(requestUser.getPassword());
            this.updateUserPassword(user);
            return Response.ok(new DefaultRespondEntity()).build();
        } catch (ArgumentException var3) {
            return Response.status(Status.BAD_REQUEST).entity(new DefaultRespondEntity("Invalid input")).build();
        } catch (AuthenticationException var4) {
            return Response.status(Status.NOT_FOUND).entity(new DefaultRespondEntity(var4.getMessage())).build();
        } catch (Exception var5) {
            return Response.status(Status.FORBIDDEN).entity(new DefaultRespondEntity(var5.getStackTrace().toString())).build();
        }
    }

    @PUT
    @Path("user/password")
    @Consumes({"application/json"})
    @Produces({"application/json"})
    public Response changePassword(ChangePasswordRequestTemplate requestUser) {
        try {
            User user = AuthenticationAPI.authenticate(requestUser);
            user.password(requestUser.getNew_password());
            this.updateUserPassword(user);
            return Response.ok(new DefaultRespondEntity()).build();
        } catch (ArgumentException var3) {
            return Response.status(Status.BAD_REQUEST).entity(new DefaultRespondEntity(var3.getMessage())).build();
        } catch (AuthenticationException var4) {
            return Response.status(Status.UNAUTHORIZED).entity(new DefaultRespondEntity(var4.getMessage())).build();
        }
    }

    @GET
    @Path("user/{email}/getPassword")
    @Consumes({"application/json"})
    @Produces({"application/json"})
    public Response emailPassword(@PathParam("email") String email) {
        try {
            Database db = new Database();
            User user = db.getUserByEmail(email.toLowerCase());
            if (user == null) {
                throw new AuthenticationException("Registered information does not match.");
            } else {
                this.SendEmail(email);
                return Response.ok(new DefaultRespondEntity()).build();
            }
        } catch (ArgumentException var4) {
            return Response.status(Status.BAD_REQUEST).entity(new DefaultRespondEntity("Invalid input")).build();
        } catch (AuthenticationException var5) {
            return Response.status(Status.NOT_FOUND).entity(new DefaultRespondEntity(var5.getMessage())).build();
        } catch (Exception var6) {
            return Response.status(Status.FORBIDDEN).entity(new DefaultRespondEntity(var6.getStackTrace().toString())).build();
        }
    }

    @POST
    @Path("user/cal")
    @Consumes({"application/json"})
    @Produces({"application/json"})
    public Response testCallum(Callum c) {
        return Response.ok(LocalDate.now()).build();
    }

    private User verifyUserInformation(User u) throws ArgumentException, AuthenticationException, Exception {
        if (u.getEmail() != null && u.getDob() != null && u.getSurname() != null && u.getFirstname() != null) {
            Database db = new Database();
            User user = db.getUserByEmail(u.getEmail().toLowerCase());
            if (user != null && user.getSurname().equalsIgnoreCase(u.getSurname()) && user.getFirstname().equalsIgnoreCase(u.getFirstname()) && user.getDob().equals(u.getDob())) {
                if (user.getPassword() != null) {
                    throw new Exception("User has been activated");
                } else {
                    return user;
                }
            } else {
                throw new AuthenticationException("Registered information does not match.");
            }
        } else {
            throw new ArgumentException();
        }
    }

    private void updateUserPassword(User u) throws ArgumentException {
        if (u.getPassword() == null) {
            throw new ArgumentException();
        } else {
            Database db = new Database();
            db.updateUserPassword(u.getId(), u.getPassword());
        }
    }

    private void SendEmail(String receiverAddress) throws Exception {
        Database db = new Database();
        String loginPassword = db.getUserByEmail(receiverAddress).getPassword();
        String myEmailAccount = "medsec.wombat@gmail.com";
        String myEmailPassword = "wombat2020";
        String myEmailSMTPHost = "smtp.gmail.com";
        Properties props = new Properties();
        props.setProperty("mail.transport.protocol", "smtp");
        props.setProperty("mail.smtp.host", myEmailSMTPHost);
        props.setProperty("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.port", "587");
        Session session = Session.getInstance(props);
        session.setDebug(true);
        MimeMessage message = createMimeMessage(session, myEmailAccount, receiverAddress, loginPassword);
        Transport transport = session.getTransport();
        transport.connect(myEmailAccount, myEmailPassword);
        transport.sendMessage(message, message.getAllRecipients());
        transport.close();
    }

    private static MimeMessage createMimeMessage(Session session, String sendMail, String receiveMail, String loginPassword) throws Exception {
        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(sendMail, "medsec admin", "UTF-8"));
        message.setRecipient(RecipientType.TO, new InternetAddress(receiveMail));
        message.setSubject("Your password", "UTF-8");
        String content = "Hello, this is your password: " + loginPassword;
        message.setContent(content, "text/html;charset=UTF-8");
        message.setSentDate(new Date());
        message.saveChanges();
        return message;
    }
}
