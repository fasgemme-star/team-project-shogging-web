package manage.client;

import java.security.SecureRandom;
import java.util.stream.Collectors;

public class PasswordGenerator {
    private static final String CHAR_LOWER = "abcdefghijklmnopqrstuvwxyz";
    private static final String CHAR_UPPER = CHAR_LOWER.toUpperCase();
    private static final String NUMBER = "0123456789";
    private static final String OTHER = "!@#$%&*()_+-=[]?";
    private static final String PASSWORD_ALLOW = CHAR_LOWER + CHAR_UPPER + NUMBER + OTHER;

    private static SecureRandom random = new SecureRandom();

    public static String generatePassword(int length) {
        if (length < 1) throw new IllegalArgumentException();

        return random.ints(length, 0, PASSWORD_ALLOW.length())
                .mapToObj(PASSWORD_ALLOW::charAt)
                .map(Object::toString)
                .collect(Collectors.joining());
    }
    
}
