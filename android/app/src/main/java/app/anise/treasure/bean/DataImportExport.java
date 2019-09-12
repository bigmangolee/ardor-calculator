package app.anise.treasure.bean;

public class DataImportExport {
    private String config;
    private String account;

    public DataImportExport(String config, String account) {
        this.config = config;
        this.account = account;
    }

    public String getConfig() {
        return config;
    }

    public void setConfig(String config) {
        this.config = config;
    }

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }
}
