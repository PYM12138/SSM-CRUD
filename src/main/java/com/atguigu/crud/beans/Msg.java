package com.atguigu.crud.beans;

import java.util.HashMap;
import java.util.Map;

public class Msg {
    /*
    * 通用的消息提示(这里是自定义的，作用于整个CRUD)
    * */
    private Integer code;
    private String msg;
    private Map<String,Object> extend=new HashMap<String,Object>();

    //成功消息提示信息
    public static Msg success(){
        Msg msg = new Msg();
        msg.setCode(100);
        msg.setMsg("操作成功");
        return  msg;
    }
    //失败的消息提示信息
    public static Msg fail(){
        Msg msg = new Msg();
        msg.setCode(200);
        msg.setMsg("操作失败！");
        return  msg;
    }
    //信息扩展
    public Msg add(String key,Object value){
        this.getExtend().put(key, value);
        return this;
    }

    public Integer getCode() {
        return code;
    }

    public void setCode(Integer code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Map<String, Object> getExtend() {
        return extend;
    }

    public void setExtend(Map<String, Object> extend) {
        this.extend = extend;
    }
}
