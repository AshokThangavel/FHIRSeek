Class FHIRSeek.FHIR.Utils Extends %RegisteredObject
{

ClassMethod AddExternalFHIRServer(json As %DynamicObject) As %Status
{
	Set:'$IsObject(json) json = ##class(%DynamicAbstractObject).%FromJSON(json)
	Set obj = ##Class(FHIRSeek.FHIR.Servers).%New()
	Set st = obj.%JSONImport(json)
	Set rtn  = obj.%Save()
	Return rtn
}

ClassMethod UpdateFHIRServer(json As %DynamicObject, pFHIRServerId As %String = "") As %Status
{
	Set:'$IsObject(json) json = ##class(%DynamicAbstractObject).%FromJSON(json)
	Set obj = ##Class(FHIRSeek.FHIR.Servers).%OpenId(pFHIRServerId)
	Set st = obj.%JSONImport(json)
	Set rtn  = obj.%Save()
	Return rtn
}

ClassMethod DeleteFHIRServer(pFHIRServerId As %String = "") As %Status [ CodeMode = expression ]
{
##Class(FHIRSeek.FHIR.Servers).%DeleteId(pFHIRServerId)
}

ClassMethod GetFHIRServerInfo(pFHIRServerId As %String = "", StringOrJSON As %Boolean = 1)
{
	Set response=""
	Do ##Class(FHIRSeek.FHIR.Servers).%OpenId(pFHIRServerId).%JSONExportToString(.string)
	If 'StringOrJSON Quit string
	If string'="" {
		Set response = ##class(%DynamicAbstractObject).%FromJSON(string)
	}
	Return response
}

ClassMethod GetFHIRUrl(pFHIRServerId As %String = "") As %String [ CodeMode = expression ]
{
##Class(FHIRSeek.FHIR.Servers).%OpenId(pFHIRServerId).FullUrl
}

ClassMethod FullHttpUrl(pFHIRServerId As %String = "")
{
	Set obj = ##Class(FHIRSeek.FHIR.Servers).%OpenId(pFHIRServerId)
	Return $Select(obj.Https:"https://",1:"http://")_obj.Host_$S(obj.Port'="":":"_obj.Port,1:"")_obj.FHIRUrl
}

ClassMethod GetAuthType(pFHIRServerId As %String = "") As FHIRSeek.FHIR.Auth.FHIRServer [ CodeMode = expression ]
{
##Class(FHIRSeek.FHIR.Servers).%OpenId(pFHIRServerId).AuthType
}

ClassMethod ValidateAuth(pFHIRServerId As %String = "") As %String
{
	#dim Auth As FHIRSeek.FHIR.Auth.FHIRServer = ..GetAuthType(pFHIRServerId)
	if Auth.AuthType="basic" Set auth= "basic "_Auth.PasswordHash
	Ret auth
}

Query GetFHIRServers() As %SQLQuery
{
	SELECT JSON_ARRAYAGG(JSON_OBJECT(
					'id':ID,
					'name':FHIRServerName,
					'url':FHIRUrl,
					'version':version,
					'active':Active,
					'description':Description,
					'IsISCFHIRServer':IsISCFHIRServer
					)
			) FROM FHIRSeek_FHIR.Servers
}

}
