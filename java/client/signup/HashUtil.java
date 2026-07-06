package client.signup;

import java.security.MessageDigest;

public class HashUtil {

	    private HashUtil() {
	    }

	    public static String hashingPassword(String pw) {

	        if (pw == null) {
	            return null;
	        }

	        String hash = "";

	        try {
	            MessageDigest md = MessageDigest.getInstance("SHA-256");

	            byte[] bytes = md.digest(pw.getBytes());

	            StringBuilder sb = new StringBuilder();

	            for (byte b : bytes) {
	                sb.append(String.format("%02x", b));
	            }

	            hash = sb.toString();

	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	        return hash;
	    }
}
