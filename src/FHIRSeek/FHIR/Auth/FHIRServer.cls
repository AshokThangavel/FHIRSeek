Class FHIRSeek.FHIR.Auth.FHIRServer Extends (%Persistent, %JSON.Adaptor)
{

Property AuthType As %String;

Property PasswordHash As %String;

Storage Default
{
<Data name="FHIRServerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AuthType</Value>
</Value>
<Value name="3">
<Value>PasswordHash</Value>
</Value>
</Data>
<DataLocation>^FHIRSeek.FHIR.Auth.FHIRServerD</DataLocation>
<DefaultData>FHIRServerDefaultData</DefaultData>
<IdLocation>^FHIRSeek.FHIR.Auth.FHIRServerD</IdLocation>
<IndexLocation>^FHIRSeek.FHIR.Auth.FHIRServerI</IndexLocation>
<StreamLocation>^FHIRSeek.FHIR.Auth.FHIRServerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
