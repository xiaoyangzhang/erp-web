<?xml version="1.0" encoding="utf-8"?>
<#assign CertificateMap = {"127":"1","128":"4","129":"10","130":"9","131":"10","132":"10","463":"2","":"10" } >
<#assign YihgKeys = ["127","128","129","130","131","132","463",""] >
<TripItems>
	<#list groupsData as groupData>
    <TripItem>
        <Abstract>
            <LineName>${((groupData.groupInfo.productName)!"")?replace("<"," ")?replace(">"," ")?replace("/"," ")}</LineName>
            <TravelAgencyId>${(requestParam.accountNum)!""}</TravelAgencyId>
            <TravelAgencyName>${(requestParam.accountNumName)!""}</TravelAgencyName>
            <TeamId>${(groupData.groupInfo.groupCode)!""}</TeamId>
            <TeamType>4</TeamType>
            <TouristRegion></TouristRegion>
            <TouristCountry></TouristCountry>
            <Operator>${(requestParam.accountPlanNum)!""}</Operator>
            <OperatorName>${(requestParam.accountPlanNumName)!""}</OperatorName>
            <OperatorMobile></OperatorMobile>
            <OperatorKinPhone></OperatorKinPhone>
            <Planer></Planer>
            <PlanerName></PlanerName>
            <PlanerPhone></PlanerPhone>
            <Insurance></Insurance>
            <Total>${((groupData.groupInfo.totalAdult)!0)+((groupData.groupInfo.totalChild)!0)}</Total>
            <Adults>${(groupData.groupInfo.totalAdult)!0}</Adults>
            <Kids>${(groupData.groupInfo.totalChild)!0}</Kids>
            <Auditor></Auditor>
            <Auditorname></Auditorname>
            <AuditTime></AuditTime>
            <StartTime>
            <#if (groupData.groupInfo.dateStart)?? >
            	 ${(groupData.groupInfo.dateStart)?string("yyyy-MM-dd")}
            </#if>
            </StartTime>
            <EndTime>
            <#if (groupData.groupInfo.dateEnd)?? >
            	${(groupData.groupInfo.dateEnd)?string("yyyy-MM-dd")}
            </#if>
            </EndTime>
            <Days>${(groupData.groupInfo.daynum)!""}</Days>
            <ReceivePlace></ReceivePlace>
            <SendPlace></SendPlace>
            <GatherPlace></GatherPlace>
            <GatherTime></GatherTime>
            <OutPort></OutPort>
            <EnterPort></EnterPort>
            <Info>
            	${((groupData.groupInfo.serviceStandard)!"")?replace("<"," ")?replace(">"," ")?replace("/"," ")}
            </Info>
            <Note>${((groupData.groupInfo.remark)!"")?replace("<"," ")?replace(">"," ")?replace("/"," ")}</Note>
            <SetupTime>
             <#if setupTime?? >
            	 ${setupTime?string("yyyy-MM-dd")}
            </#if>
            </SetupTime>
        </Abstract>
        
        <Items>
          
        </Items>

        <Routines>
        
        <#list groupData.routes as route >
            <Routine>
                <PlanDate>
                <#if (route.groupDate)?? >
                	${(route.groupDate?string("yyyy-MM-dd"))!""}
                </#if>
                </PlanDate>
                <PlanInfo>${((route.routeDesp)!"")?replace("<"," ")?replace(">"," ")?replace("/"," ")}</PlanInfo>
                <Bus>1</Bus>
                <Plane>0</Plane>
                <Train>0</Train>
                <Ship>0</Ship>
                <Breadfast>${ ( ((route.breakfast)!"") == "" || ((route.breakfast)!"") == "×" )?then(0,1)}</Breadfast>
                <Lunch>${ ( ((route.lunch)!"") == "" || ((route.lunch)!"") == "×" )?then(0,1) }</Lunch>
                <Supper>${ ( ((route.supper)!"") == "" || ((route.supper)!"") == "×" )?then(0,1) }</Supper>
                <Lodging>${((route.hotelName)!"")?replace("<"," ")?replace(">"," ")}</Lodging>
            </Routine>
         </#list> 
           
        </Routines>

        <Tourists>
        <#list groupData.guests as guest >
            <Tourist>
                <Name>${(guest.name)!""}</Name>
                <CertificateType><#if YihgKeys?seq_contains(((guest.certificateTypeId)!"")?string) >${CertificateMap[((guest.certificateTypeId)!"")?string]}<#else>10</#if></CertificateType>
                <CertificateNum>${(guest.certificateNum)!""}</CertificateNum>
                <Gender>${(((guest.gender)!0) == 0)?then("女","男")}</Gender>
                <Age>${(guest.age)!""}</Age>
                <Nationality>${(guest.nativePlace)!""}</Nationality>
                <Mobile>${(guest.mobile)!""}</Mobile>
                <KinPhone></KinPhone>
                <PriorAgencyName></PriorAgencyName>
                <TravelInsurance>0</TravelInsurance>
                <CasualtyInsurance>0</CasualtyInsurance>
                <SpecialInsurance>0</SpecialInsurance>
            </Tourist>
          </#list>  
        </Tourists>
    </TripItem>
	</#list>
</TripItems>