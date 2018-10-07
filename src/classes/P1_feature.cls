public class P1_feature {

    public static void printHello() {
        System.debug('Hello!');
    }

    public static Account getNewAccount(String name) {
        return new Account(
                Name = name
        );
    }
}
