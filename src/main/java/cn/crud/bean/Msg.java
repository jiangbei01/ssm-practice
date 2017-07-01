package cn.crud.bean;

import java.util.HashMap;
import java.util.Map;

/**
 * 通用的返回信息的类
 *
 */
public class Msg {

	//状态码，自定义一些状态码对应的状态
	private int code;
	//提示信息
	private String msg;
	
	//用户给浏览器的数据，比如说返回的PageInfo信息
	private Map<String,Object> map = new HashMap<String,Object>();

	/**
	 * 操作成功的静态方法
	 * @return
	 */
	public static Msg success(){
		Msg result = new Msg();
		//这里100表示成功
		result.setCode(100);
		result.setMsg("操作成功");
		return result;
	}
	
	/**
	 * 操作失败的静态方法
	 * @return
	 */
	public static Msg fail(){
		Msg result = new Msg();
		//这里200表示失败
		result.setCode(200);
		result.setMsg("操作失败");
		return result;
	}
	/**
	 * 快捷添加信息的方法
	 * @return
	 */
	public Msg add(String key,Object value){
		this.getMap().put(key, value);
		return this;
	}
	
	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	public Map<String, Object> getMap() {
		return map;
	}

	public void setMap(Map<String, Object> map) {
		this.map = map;
	}
	
	
}
