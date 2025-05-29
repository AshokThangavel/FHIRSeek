Class FHIRSeek.Web.Base Extends (%CSP.Page, FHIRSeek.Web.Utils)
{

Parameter HomeScreenCls As STRING [ Final, Internal ] = "FHIRSeek.Web.Home.cls";

Parameter ICONClass As STRING [ Final, Internal ] = "FHIRSeek.Web.Icons";

Parameter Screen As STRING;

ClassMethod OnPage() As %Status
{
	Do ..OnPageCSPROOT()
}

/// Write the contents of xData tag
ClassMethod LoadCSS() As %Status
{
    Set obj = ##class(%Dictionary.CompiledXData).%OpenId($classname()_"||"_"css")
    Return:(obj = "") $$$OK
    Set xdata = obj.Data
    Set status = ##class(%XML.TextReader).ParseStream(xdata, .textreader)
    While textreader.Read() {
    	If (textreader.NodeType="chars") {
        	Write textreader.Value
    	}
    }
    Return $$$OK
}

ClassMethod svgs(svgName) As %String
{
    Set obj = ##class(%Dictionary.CompiledXData).%OpenId(..#ICONClass_"||"_svgName)
    Return:(obj = "") $$$OK
    Set xdata = obj.Data
    Set svg=""
    While 'xdata.AtEnd {
    	Set svg=svg_xdata.Read()
    }
    Return svg
}

ClassMethod OnPageCSPROOT() As %Boolean
{
	Do ..OnPageHTML()
}

ClassMethod OnPageHEAD() As %Boolean
{
	Write !,(..HyperEventHead(0,0))
}

ClassMethod OnPageHTML() As %Boolean
{
	Write !
	Do ..OnPageHEAD()
	Write !,!
	Do ..OnPageBODY()
}

ClassMethod OnPageBODY()
{
	Write "<title>FHIR Seek</title>"
	Write "<style>"
	Do ..LoadCSS()
	Write "</style>"
	Write !
	Write "<h1>"_..#Screen_"</span></h1>"
	Quit $$$OK
}

ClassMethod DecodeDecrypt(EncryptedText) [ CodeMode = expression ]
{
$Select('$IsObject(%session)!(%session=""): EncryptedText,
		1:..Decrypt($SYSTEM.Encryption.Base64Decode($zconvert(EncryptedText,"I","URL"))))
}

/// this will encypt against the session key and base 64 encode it (not sure we need to url encode)
ClassMethod EncryptEncode(x) [ CodeMode = expression ]
{
$Select('$IsObject(%session)!(%session=""): x,
				  1: $zconvert($SYSTEM.Encryption.Base64Encode(..Encrypt(x)),"O","URL")
)
}

}
