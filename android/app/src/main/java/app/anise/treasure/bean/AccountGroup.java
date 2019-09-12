
package app.anise.treasure.bean;


public class AccountGroup {
    private int groupId = -1;
    private boolean isPrivate = false;
    private String name;
    private String remarks;
    private long createTime;
    private long updateTime;
    private int order;

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

    public boolean isPrivate() {
        return isPrivate;
    }

    public void setPrivate(boolean aPrivate) {
        isPrivate = aPrivate;
    }

    public void resetValues(AccountGroup accountGroup){
        name = accountGroup.name;
        remarks = accountGroup.remarks;
        createTime = accountGroup.createTime;
        updateTime = accountGroup.updateTime;
        order = accountGroup.order;
        groupId = accountGroup.groupId;
        isPrivate = accountGroup.isPrivate;
    }
}
