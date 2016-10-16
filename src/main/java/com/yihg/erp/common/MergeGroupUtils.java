package com.yihg.erp.common;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

public class MergeGroupUtils {
	public static boolean hasSame(List<? extends Object> list) {
		if (null == list)
			return false;
		return 1 == new HashSet<Object>(list).size();
	}
	
	public static boolean hasStateSame(List<? extends Object> list) {
		if (null == list)
			return false;
		if(!list.contains(1)){
			return false;
		}
		return 1 == new HashSet<Object>(list).size();
	}
	
	public static void main(String[] args) {
		List<Integer> list  = new ArrayList<Integer>();
		
		list.add(1);
		list.add(2);
		
		System.out.println(hasSame(list));
		
		
	}
}
