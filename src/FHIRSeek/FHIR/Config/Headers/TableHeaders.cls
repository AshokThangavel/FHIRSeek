Class FHIRSeek.FHIR.Config.Headers.TableHeaders Extends %Persistent
{

Property Resource As %String(MAXLEN = 100);

Property Headers As FHIRSeek.FHIR.Config.Headers.ActiveHeaders;

Storage Default
{
<Data name="TableHeadersDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Resource</Value>
</Value>
<Value name="3">
<Value>Headers</Value>
</Value>
</Data>
<DataLocation>^FHIRSeek.FHIR.Config("TableHeaders")</DataLocation>
<DefaultData>TableHeadersDefaultData</DefaultData>
<IdLocation>^FHIRSeek.FHIR.Config("TableHeaders")</IdLocation>
<IndexLocation>^FHIRSeek.FHIR.Config("TableHeadersI")</IndexLocation>
<StreamLocation>^FHIRSeek.FHIR.Config("TableHeadersS")</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
