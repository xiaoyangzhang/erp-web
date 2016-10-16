/**
 * 分析身份证籍贯信息，获取省份信息
 */

function nativeInfo(nativeplace){
	this.nativeplace = nativeplace;
	this.province=function(){
		
		if(nativeplace){
			//直辖市
			if(nativeplace.indexOf('北京')==0){
				return "{proid:12,proname:'北京'}";
			}
			if(nativeplace.indexOf('天津')==0){
				return "{proid:37,proname:'天津'}";
			}
			if(nativeplace.indexOf('重庆')==0){
				return "{proid:43,proname:'重庆'}";
			}
			if(nativeplace.indexOf('上海')==0){
				return "{proid:34,proname:'上海'}";
			}
			//省
			if(nativeplace.indexOf('安徽')==0){
				return "{proid:10,proname:'安徽'}";
			}
			if(nativeplace.indexOf('福建')==0){
				return "{proid:13,proname:'福建'}";
			}
			if(nativeplace.indexOf('甘肃')==0){
				return "{proid:14,proname:'甘肃'}";
			}
			if(nativeplace.indexOf('广东')==0){
				return "{proid:15,proname:'广东'}";
			}
			if(nativeplace.indexOf('贵州')==0){
				return "{proid:17,proname:'贵州'}";
			}
			if(nativeplace.indexOf('海南')==0){
				return "{proid:18,proname:'海南'}";
			}
			if(nativeplace.indexOf('河北')==0){
				return "{proid:19,proname:'河北'}";
			}
			if(nativeplace.indexOf('河南')==0){
				return "{proid:20,proname:'河南'}";
			}
			if(nativeplace.indexOf('黑龙江')==0){
				return "{proid:21,proname:'黑龙江'}";
			}
			if(nativeplace.indexOf('湖北')==0){
				return "{proid:22,proname:'湖北'}";
			}
			if(nativeplace.indexOf('湖南')==0){
				return "{proid:23,proname:'湖南'}";
			}
			if(nativeplace.indexOf('吉林')==0){
				return "{proid:24,proname:'吉林'}";
			}
			if(nativeplace.indexOf('江苏')==0){
				return "{proid:25,proname:'江苏'}";
			}
			if(nativeplace.indexOf('江西')==0){
				return "{proid:26,proname:'江西'}";
			}
			if(nativeplace.indexOf('辽宁')==0){
				return "{proid:27,proname:'辽宁'}";
			}
			if(nativeplace.indexOf('青海')==0){
				return "{proid:30,proname:'青海'}";
			}
			if(nativeplace.indexOf('山东')==0){
				return "{proid:31,proname:'山东'}";
			}
			if(nativeplace.indexOf('山西')==0){
				return "{proid:32,proname:'山西'}";
			}
			if(nativeplace.indexOf('陕西')==0){
				return "{proid:33,proname:'陕西'}";
			}
			if(nativeplace.indexOf('四川')==0){
				return "{proid:35,proname:'四川'}";
			}
			if(nativeplace.indexOf('台湾')==0){
				return "{proid:36,proname:'台湾'}";
			}
			if(nativeplace.indexOf('云南')==0){
				return "{proid:41,proname:'云南'}";
			}
			if(nativeplace.indexOf('浙江')==0){
				return "{proid:42,proname:'浙江'}";
			}
			//自治区			
			if(nativeplace.indexOf('内蒙古')==0){
				return "{proid:28,proname:'内蒙古'}";
			}
			if(nativeplace.indexOf('广西')==0){
				return "{proid:16,proname:'广西'}";
			}
			if(nativeplace.indexOf('西藏')==0){
				return "{proid:16,proname:'西藏'}";
			}
			if(nativeplace.indexOf('宁夏')==0){
				return "{proid:29,proname:'宁夏'}";
			}
			if(nativeplace.indexOf('新疆')==0){
				return "{proid:40,proname:'新疆'}";
			}
			if(nativeplace.indexOf('香港')==0){
				return "{proid:39,proname:'香港'}";
			}
			if(nativeplace.indexOf('澳门')==0){
				return "{proid:11,proname:'澳门'}";
			}
		}
		return "{proid:-1,proname:''}";
	}
}