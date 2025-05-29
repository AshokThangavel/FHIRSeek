Class FHIRSeek.FHIR.Config.Headers.HeaderTab Extends %Persistent
{

Property Name As %String(MAXLEN = 100);

Property Type As %String(MAXLEN = 90);

Storage Default
{
<Data name="HeaderTabDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^FHIRSeek.FHIR.CoB892.HeaderTabD</DataLocation>
<DefaultData>HeaderTabDefaultData</DefaultData>
<IdLocation>^FHIRSeek.FHIR.CoB892.HeaderTabD</IdLocation>
<IndexLocation>^FHIRSeek.FHIR.CoB892.HeaderTabI</IndexLocation>
<StreamLocation>^FHIRSeek.FHIR.CoB892.HeaderTabS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
