Class FHIRSeek.Web.Utils Extends %RegisteredObject
{

ClassMethod CheckAndUpdateISCFHIRServers()
{
 set list = ##class(HS.FHIRServer.API.InteractionsStrategy).GetEndpointInfo()
 set ptr = 0
 Set arr=[]
 while $listnext(list, ptr, entry) {
	Set url = $listget(entry, 1)
	Set active = '(url [ "svc:")
	&SQL(SELECT COUNT(*) INTO :fhirServerExist FROM FHIRSeek_FHIR.Servers WHERE FHIRUrl=:url)
	If 'fhirServerExist {
		Set json = {"FHIRServerName":("InterSystems"),"FHIRUrl":(url),"Active":(active),"Version":($P(url,"/",*)),"Description":("InterSystems FHIR Server")}
		Set sc = ##Class(FHIRSeek.FHIR.Utils).AddExternalFHIRServer(json)

	}
 }
}

ClassMethod GetFHIRServers()
{
	Do ..CheckAndUpdateISCFHIRServers()
	Set tResult = ##class(FHIRSeek.FHIR.Utils).GetFHIRServersFunc()
	Do tResult.%Next()
	Set res = tResult.%GetData(1)
	Return [].%FromJSON(res)
}

ClassMethod SendGetRequest(pFHIRServerId As %String, pUrl As %String)
{
	Set http = ##Class(FHIRSeek.API.RESTRequest).%New(pFHIRServerId,"/metadata")
	Return http.GetReq()
}

ClassMethod IsPrimitiveDT(pDataType) [ CodeMode = expression ]
{
pDataType?1(1"time",1"date",1"string",1"url",1"boolean",1"uuid",1"dateTime",1"decimal",1"code",1"id",1"integer",1"token")
}

ClassMethod CreateAuth(pFHIRServerId As %String = "") As %String
{
	#dim auth As FHIRSeek.FHIR.Auth.FHIRServer = ##class(FHIRSeek.FHIR.Utils).GetAuthType(pFHIRServerId)
	If auth.AuthType="basic" {
		return auth.PasswordHas
	}
	return ""
}

}
