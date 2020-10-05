package uk.co.gresearch.siembol.configeditor.common;

import java.util.ArrayList;
import java.util.List;

public class UserInfo {
    private String userName;
    private String email;
    private List<String> groups = new ArrayList<>();

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public List<String> getGroups() {
        return groups;
    }

    public void setGroups(List<String> groups) {
        this.groups = groups;
    }
}
