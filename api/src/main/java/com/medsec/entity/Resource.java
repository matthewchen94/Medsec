package com.medsec.entity;

public class Resource {
    private String id;
    private String uid;
    private String name;
    private String website;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getWebsite() {
        return website;
    }

    public void setWebsite(String website) {
        this.website = website;
    }

    public Resource id(final String id) {
        this.id = id;
        return this;
    }

    public Resource uid(final String uid) {
        this.uid = uid;
        return this;
    }

    public Resource name(final String name) {
        this.name = name;
        return this;
    }

    public Resource website(final String website) {
        this.website = website;
        return this;
    }
}
