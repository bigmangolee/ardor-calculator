
package app.anise.treasure.store;



import java.util.ArrayList;
import java.util.HashMap;

import app.anise.calculator.AppGlobal;
import app.anise.treasure.bean.Account;
import app.anise.treasure.bean.AccountGroup;


public class ArdorAccountStore {
    private int maxGroupId=0;
    private int maxAccountId=0;
    private ArrayList<AccountGroup> groups = new ArrayList<>();
    private HashMap<Integer,ArrayList<Account>> accounts = new HashMap<>();

    public int getMaxGroupId() {
        return maxGroupId;
    }

    public void setMaxGroupId(int maxGroupId) {
        this.maxGroupId = maxGroupId;
    }

    public int getMaxAccountId() {
        return maxAccountId;
    }

    public void setMaxAccountId(int maxAccountId) {
        this.maxAccountId = maxAccountId;
    }

    public ArrayList<AccountGroup> getGroups() {
        if(groups != null && !AppGlobal.getInstance().isPrivateShow()){
            ArrayList<AccountGroup> list = new ArrayList<>();
            for(AccountGroup accountGroup : groups){
                if(!accountGroup.isPrivate()){
                    list.add(accountGroup);
                }
            }
            return list;
        }
        return groups;
    }

    public void setGroups(ArrayList<AccountGroup> groups) {
        this.groups = groups;
    }

    public HashMap<Integer, ArrayList<Account>> getAccounts() {
        return accounts;
    }

    public void setAccounts(HashMap<Integer, ArrayList<Account>> accounts) {
        this.accounts = accounts;
    }

    public void addNewGroup(AccountGroup group){
        group.setGroupId(++maxGroupId);
        group.setCreateTime(System.currentTimeMillis());
        group.setUpdateTime(System.currentTimeMillis());
        groups.add(group);
    }

    private void addGroup(AccountGroup group){
        group.setCreateTime(System.currentTimeMillis());
        group.setUpdateTime(System.currentTimeMillis());
        groups.add(group);
    }

    public void updateGroup(AccountGroup group){
        AccountGroup accountGroup = getGroup(group.getGroupId());
        if(null != accountGroup){
            accountGroup.resetValues(group);
            accountGroup.setUpdateTime(System.currentTimeMillis());
        }
    }

    public AccountGroup getGroup(int groupId){
        for(AccountGroup g : groups){
            if(groupId == g.getGroupId()){
                return g;
            }
        }
        return null;
    }

    public boolean removeGroup(int groupId){
        AccountGroup removeGroup = null;
        for(AccountGroup group : groups){
            if(groupId == group.getGroupId()){
                removeGroup = group;
            }
        }
        if(removeGroup != null){
            groups.remove(removeGroup);
        }
        return true;
    }

    public void addNewAccount( Account account,int groupId){
        ArrayList<Account> list = getAccounts(groupId);
        if(list == null){
            list = new ArrayList<>();
            accounts.put(groupId,list);
        }
        account.setId(++maxAccountId);
        account.setGroupId(groupId);
        account.setCreateTime(System.currentTimeMillis());
        account.setUpdateTime(System.currentTimeMillis());
        list.add(account);
    }

    public boolean updateAccount( Account account){
        Account localAccount = getAccount(account);
        if(localAccount != null){
            localAccount.resetValues(account);
            localAccount.setUpdateTime(System.currentTimeMillis());
            return true;
        }else{
            ArrayList<Account> list =  getAccounts(account.getGroupId());
            if(list != null){
                list.add(account);
                return true;
            }else{
                return false;
            }
        }
    }

    public boolean removeAccount( Account account){
        ArrayList<Account> list =  getAccounts(account.getGroupId());
        Account deleteAccount = null;
        for(Account a :list){
            if(a.getId() == account.getId()){
                deleteAccount = a;
            }
        }
        if(deleteAccount != null){
            list.remove(deleteAccount);
        }
        return true;
    }

    private Account getAccount( Account account){
        ArrayList<Account> list =  getAccounts(account.getGroupId());
        for(Account a :list){
            if(a.getId() == account.getId()){
                return a;
            }
        }
        return null;
    }


    public ArrayList<Account> getAccounts(int groupId) {
        return accounts.get(groupId);
    }

    /**
     * 变更帐号所在的组
     * @param account
     * @param toGroupId
     */
    public void changeAccountGroup( Account account, int toGroupId){
        ArrayList<Account> oldList = getAccounts(account.getGroupId());
        ArrayList<Account> newList = getAccounts(toGroupId);
        if(newList==null){
            return;
        }
        if(oldList != null){
            Account deleteAccount = null;
            for(Account a :oldList){
                if(a.getId() == account.getId()){
                    deleteAccount = a;
                }
            }
            if(deleteAccount != null){
                oldList.remove(deleteAccount);
            }
        }

        Account deleteAccount = null;
        for(Account a :newList){
            if(a.getId() == account.getId()){
                deleteAccount = a;
            }
        }
        if(deleteAccount != null){
            newList.remove(deleteAccount);
        }
        newList.add(account);
    }
}
