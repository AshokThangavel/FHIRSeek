Class FHIRSeek.FHIR.Servers Extends (%Persistent, %JSON.Adaptor)
{

Property FHIRServerName As %String(MAXLEN = 100);

Property FHIRUrl As %String(COLLATION = "EXACT", MAXLEN = 300);

Property Version As %String;

Property Description As %String(MAXLEN = 4096);

Property Active As %Boolean;

Property Host As %String [ InitialExpression = "localhost" ];

Property Https As %Boolean [ Calculated ];

Property FullUrl As %String(MAXLEN = 500) [ Calculated ];

Property AuthType As FHIRSeek.FHIR.Auth.FHIRServer(%JSONREFERENCE = "OBJECT");

/// Check whether local InterSystems FHIR server, You can't edit the IRIS server direclty. You have to change thorugh the FHIR configuration page
Property IsISCFHIRServer As %Boolean [ InitialExpression = 0 ];

Method FullUrlGet()
{
	Return ..Host_$S(..Port'="":":"_..Port,1:"")_..FHIRUrl
}

Method HttpsGet() As %Boolean
{
	Return $Select($P($ZCVT(..FHIRUrl,"l"),":")="https":1,1:0)
}

Property Url As %String [ Calculated ];

Method UrlGet() As %Boolean
{
	If ..FHIRUrl["http" {
		Return "/"_$P(..FHIRUrl,"/",4,*)
	}
	Else {
		Return ..FHIRUrl
	}
}

Property Port As %String [ InitialExpression = {^%SYS("WebServer","Port")} ];

Storage Default
{
<Data name="ServersDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FHIRServerName</Value>
</Value>
<Value name="3">
<Value>FHIRUrl</Value>
</Value>
<Value name="4">
<Value>Version</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
<Value name="7">
<Value>Host</Value>
</Value>
<Value name="8">
<Value>AuthType</Value>
</Value>
<Value name="9">
<Value>Port</Value>
</Value>
<Value name="10">
<Value>IsISCFHIRServer</Value>
</Value>
</Data>
<DataLocation>^FHIRSeek.FHIR.ServersD</DataLocation>
<DefaultData>ServersDefaultData</DefaultData>
<ExtentSize>4</ExtentSize>
<IdLocation>^FHIRSeek.FHIR.ServersD</IdLocation>
<IndexLocation>^FHIRSeek.FHIR.ServersI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Active">
<AverageFieldSize>3</AverageFieldSize>
<OutlierSelectivity>.999999:1</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="AuthType">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="Description">
<AverageFieldSize>23.75</AverageFieldSize>
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="FHIRServerName">
<AverageFieldSize>12.75</AverageFieldSize>
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="FHIRUrl">
<AverageFieldSize>33.25</AverageFieldSize>
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="Host">
<AverageFieldSize>13.75</AverageFieldSize>
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="Port">
<AverageFieldSize>4.5</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="Version">
<AverageFieldSize>4</AverageFieldSize>
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^FHIRSeek.FHIR.ServersS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
