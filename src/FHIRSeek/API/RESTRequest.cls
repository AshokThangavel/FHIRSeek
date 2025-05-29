Class FHIRSeek.API.RESTRequest Extends %Net.HttpRequest
{

Property Connection As FHIRSeek.FHIR.Servers;

Property HttpResource As %String(MAXLEN = 200);

Parameter ContTypeFHIRJson As STRING = "application/fhir+json";

Parameter ContentTypeJSON As STRING = "application/json";

Method %OnNew(pFHIRServerId, pUrl) As %Status
{
	Set st= ##super()
	;return general http connection
	If pFHIRServerId="" Q st
	Set obj = ##class(FHIRSeek.FHIR.Servers).%OpenId(pFHIRServerId,,.err)
	If $$$ISERR(err) Q st
	Set ..HttpResource = pUrl
	Set ..Connection = obj
	Do ..NewRequest()
	Quit st
}

Method NewRequest()
{
	Set response = ""
	Set host = ..Connection.Host
	If ..Connection.Host["http" Set host = $REPLACE($REPLACE(..Connection.Host,"http://",""),"https://","")
	Set ..Server = host
	Set:..Connection.Port'="" ..Port = ..Connection.Port
	Set ..Https= ..Connection.Https
	If ..Https {
		Set ..SSLConfiguration=""
	}
	If ..Connection.AuthType.AuthType="basic" Do ..SetHeader("Authorization"," Basic "_..Connection.AuthType.PasswordHash)
	Do ..SetHeader("Accept",..#ContentTypeJSON)
	Do ..SetHeader("Content-Type",..#ContTypeFHIRJson)
}

Method GetReq() [ CodeMode = expression ]
{
..SendRequest("Get")
}

Method SendRequest(pMethod As %String)
{
	Set st = $Method(,$ZCVT(pMethod,"W"),..Connection.Url_$Select($E(..Connection.Url,"*")="/":$E(..HttpResource,2,*),1:..HttpResource))
	If $$$ISERR(st) w $SYSTEM.OBJ.DisplayError(st)
	#dim httpresponse As %Net.HttpResponse = ..HttpResponse
	If $IsObject(httpresponse) {
		If httpresponse.StatusCode '=200 {
			Write httpresponse.Data.Read()
			Quit ""
		}
		If $P(httpresponse.ContentType,";")=..#ContTypeFHIRJson {
			Set response = {}.%FromJSON(httpresponse.Data)
		}
	}
	Return response
}

}
