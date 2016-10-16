package com.yihg.erp.filter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

import org.apache.commons.lang.StringEscapeUtils;
import org.springframework.util.StringUtils;

public class XssHttpServletRequestWrapper extends HttpServletRequestWrapper {

	public XssHttpServletRequestWrapper(HttpServletRequest servletRequest) {  
        super(servletRequest);  
    }  

	public String[] getParameterValues(String parameter) {
		String[] values = super.getParameterValues(parameter);
		if (values == null) {
			return null;
		}
		int count = values.length;
		String[] encodedValues = new String[count];
		for (int i = 0; i < count; i++) {
			encodedValues[i] = cleanXSS(values[i]);
		}
		return encodedValues;
	}

	public String getParameter(String parameter) {
		String value = super.getParameter(parameter);
		if (value == null) {
			return null;
		}
		return cleanXSS(value);
	}

	public String getHeader(String name) {
		String value = super.getHeader(name);
		if (value == null)
			return null;
		return cleanXSS(value);
	}

	private String cleanXSS(String value) {
		/*value = value.replaceAll("<", "& lt;").replaceAll(">", "& gt;");
		value = value.replaceAll("\\(", "& #40;").replaceAll("\\)", "& #41;");
		value = value.replaceAll("'", "& #39;");*/
		/*value = value.replaceAll("\"", "“");
		value = value.replaceAll("\'", "‘");
		value = value.replaceAll(">", "＞");
		value = value.replaceAll("<", "＜");
		value = value.replaceAll("eval\\((.*)\\)", "");
		value = value.replaceAll("[\\\"\\\'][\\s]*javascript:(.*)[\\\"\\\']",
				"\"\"");
		value = value.replaceAll("script", "");
				
		return value;
		*/
		/*value = StringEscapeUtils.escapeHtml(value);
		value = StringEscapeUtils.escapeJavaScript(value);*/
		
		 if (StringUtils.isEmpty(value)) {  
	            return value;  
        }  
        StringBuilder sb = new StringBuilder();  
        for (int i = 0; i < value.length(); i++) {  
            char c = value.charAt(i);  
            switch (c) {  
            case '>':  
                sb.append('＞');//全角大于号  
                break;  
            case '<':  
                sb.append('＜');//全角小于号  
                break;  
            /*case '\'':  //影响json
                sb.append('‘');//全角单引号  
                break;  
            case '\"':  
                sb.append('“');//全角双引号  
                break;*/  
            case '&':  
                sb.append('＆');//全角  
                break;  
            case '\\':  
                sb.append('＼');//全角斜线  
                break;  
            case '#':  
                sb.append('＃');//全角井号  
                break;  
            default:  
                sb.append(c);  
                break;  
            }  
        }  
        return sb.toString();  
	} 
}
