
package app.anise.treasure.store;

public class AppConfigStore {

    public enum LoginMode{
        GRAPH,
        INPUT
    }

    private String randomSalt;

    private LoginMode loginMode = LoginMode.GRAPH;

    public String getRandomSalt() {
        return randomSalt;
    }

    public void setRandomSalt(String randomSalt) {
        this.randomSalt = randomSalt;
    }

    public LoginMode getLoginMode() {
        return loginMode;
    }

    public void setLoginMode(LoginMode loginMode) {
        this.loginMode = loginMode;
    }
}
