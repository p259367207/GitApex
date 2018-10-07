public class P1_feature {

    public static void printHello() {
        System.debug('Hello World!');
    }

    public static Account getNewAccount(String name) {
        return new Account(
                Name = name
        );
    }
}
