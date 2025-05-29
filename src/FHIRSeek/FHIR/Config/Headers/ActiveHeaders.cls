Class FHIRSeek.FHIR.Config.Headers.ActiveHeaders Extends %Persistent
{

Property Header As FHIRSeek.FHIR.Config.Headers.HeaderTab;

Property Active As %Boolean [ InitialExpression = 1 ];

Storage Default
{
<Data name="ActiveHeadersDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Header</Value>
</Value>
<Value name="3">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^FHIRSeek.FHIB892.ActiveHeadersD</DataLocation>
<DefaultData>ActiveHeadersDefaultData</DefaultData>
<IdLocation>^FHIRSeek.FHIB892.ActiveHeadersD</IdLocation>
<IndexLocation>^FHIRSeek.FHIB892.ActiveHeadersI</IndexLocation>
<StreamLocation>^FHIRSeek.FHIB892.ActiveHeadersS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
