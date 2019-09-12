
package app.anise.treasure.bean;

import java.io.Serializable;

public class Account implements Serializable{
    private int id = -1;
    private int groupId = -1;
    private String name;
    private String address;
    private String account;
    private String password;
    private String remarks;
    private int order;
    private long createTime;
    private long updateTime;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getGroupId() {
        return groupId;
    }

    public void setGroupId(int groupId) {
        this.groupId = groupId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public int getOrder() {
        return order;
    }

    public void setOrder(int order) {
        this.order = order;
    }

    public long getCreateTime() {
        return createTime;
    }

    public void setCreateTime(long createTime) {
        this.createTime = createTime;
    }

    public long getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(long updateTime) {
        this.updateTime = updateTime;
    }

    public void resetValues(Account account){
        id = account.id;
        groupId = account.groupId;
        name = account.name;
        address = account.address;
        this.account = account.account;
        password = account.password;
        remarks = account.remarks;
        createTime = account.createTime;
        updateTime = account.updateTime;
        order = account.order;
    }
}
