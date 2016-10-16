//15位身份证号码=6位地区代码+6位生日+3位编号
//15位身份证号码各位的含义: 
//1-2位省、自治区、直辖市代码； 
//3-4位地级市、盟、自治州代码； 
//5-6位县、县级市、区代码； 
//7-12位出生年月日,比如670401代表1967年4月1日,与18位的第一个区别； 
//13-15位为顺序号，其中15位男为单数，女为双数；
//与18位身份证号的第二个区别：没有最后一位的验证码。 
//********************************
//18位身份证号码=6位地区代码+8位生日+3位编号+1位检验码
function Card(cardno){
	this.cardno = cardno;
	this.addr=function(){
		var exist = false;
		var regioncode = cardno.substr(0,6);
		for(var i=0;i< region.length && !exist;i++){
			if(region[i].c==regioncode){
				exist = true;
				return region[i].n;				
			}
		}
		return "";		
	}
	this.age=function(){
		var year = 1900;
		if(cardno.length==15){
			year = cardno.substr(6,2);
			year = parseInt("19".concat(year));
		}
		if(cardno.length==18){
			year = cardno.substr(6,4);
		}
		var date = new Date();
		return date.getFullYear()-year;
	}
	this.sex=function(){
		var num = 0;
		if(cardno.length==15){
			num = cardno.substr(14,1);
		}
		if(cardno.length==18){
			num = cardno.substr(16,1);
		}
		return num%2==0?"女":"男";
	}
}