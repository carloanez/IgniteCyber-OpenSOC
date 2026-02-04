Attribute VB_Name = "Module1"
Option Explicit

' TRAINING-ONLY: This macro does NOT execute external commands.
' Goal: practice deobfuscation + IOC extraction.

Private Function d(ByVal s As String) As String
    Dim i As Integer, out As String
    out = ""
    For i = 1 To Len(s)
        out = out & Chr(Asc(Mid(s, i, 1)) - 1)
    Next i
    d = out
End Function

Public Sub AutoOpen()
    Dim a As String, b As String, c As String, u As String
    a = "iyyqt;00qpsubm.bqfygjq.qbzofout\\jowbmje0bvu i?dbnqbjho>D K.033"
    b = "0tubujd0vqebuf/iub"
    c = "KjoefsKbdlbm"
    u = Replace(d(a), " ", "") & d(b)

    ' Output the decoded URL to a document property (simulates staging without execution)
    ActiveDocument.BuiltInDocumentProperties("Comments") = "BeaconURL=" & u & ";Tag=" & d(c)
End Sub
