package com.medsec.dao;

import com.medsec.entity.ResourceFile;

public interface ResourceFileMapper {
    ResourceFile selectRFileById(String id);
    String maxID();
    String getRFileLink(String id);
    void insertRFile(ResourceFile file);
    void updateRFile(ResourceFile file);
}
