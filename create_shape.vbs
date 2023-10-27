'接触了一下 visio的宏编程，实现了重复图的自动化生成

Sub Macro4()
    Dim DiagramServices As Integer
    Dim shape As Visio.shape
    DiagramServices = ActiveDocument.DiagramServicesEnabled
    ActiveDocument.DiagramServicesEnabled = visServiceVersion140 + visServiceVersion150
    Application.Windows.ItemEx("base.vsdx").Activate
    
    Dim lengh As Integer
    Dim width As Integer
    Dim fn As Integer 'font number
    lengh = 5
    width = 5
    fn = 20
    
    
    Dim I As Integer
    Dim j As Integer
    For I = 0 To lengh
        For j = 0 To width
            Set shape = Application.ActiveWindow.Page.Drop(Application.Documents.Item("BASIC_M.vssx").Masters.ItemU("Square"), 0, 0)
            Dim num As Double
            num = Format(Rnd(), "0.00")
            setColor shape.id, CInt((1 - num) * 255), CInt((1 - num) * 100), CInt((1 - num) * 100)
            setFont shape.id, num, fn
            setSize shape.id, I, j
        Next
    Next
    
    ActiveDocument.DiagramServicesEnabled = DiagramServices

End Sub
'set per shape point, lengh width.
Sub setSize(ByVal id As Integer, ByVal I As Integer, ByVal j As Integer)

Application.ActiveWindow.Page.Shapes.ItemFromID(id).CellsSRC(visSectionObject, visRowXFormOut, visXFormPinX).FormulaU = "" & 21 * I & "mm"
Application.ActiveWindow.Page.Shapes.ItemFromID(id).CellsSRC(visSectionObject, visRowXFormOut, visXFormPinY).FormulaU = "" & 21 * j & "mm"
Application.ActiveWindow.Page.Shapes.ItemFromID(id).CellsSRC(visSectionObject, visRowXFormOut, visXFormWidth).FormulaU = "20 mm"
Application.ActiveWindow.Page.Shapes.ItemFromID(id).CellsSRC(visSectionObject, visRowXFormOut, visXFormHeight).FormulaU = "20 mm"

End Sub
'set font number and text of shape
Sub setFont(ByVal id As Integer, ByVal val As Double, ByVal fontNumb As Integer)

    Dim vsoCharacters1 As Visio.Characters
    Dim str As String
    Set vsoCharacters1 = Application.ActiveWindow.Page.Shapes.ItemFromID(id).Characters
    str = str & val
    vsoCharacters1.Begin = 0
    vsoCharacters1.Text = str
    vsoCharacters1.End = Len(str)
    vsoCharacters1.CharProps(visCharacterSize) = fontNumb

End Sub
'set color of shape
Sub setColor(ByVal id As Integer, ByVal r As Integer, ByVal g As Integer, ByVal b As Integer)

    Application.ActiveWindow.Page.Shapes.ItemFromID(id).CellsSRC(visSectionObject, visRowFill, visFillForegnd).FormulaU = "THEMEGUARD(RGB(" & r & "," & g & "," & b & "))"
    Application.ActiveWindow.Page.Shapes.ItemFromID(id).CellsSRC(visSectionObject, visRowFill, visFillPattern).FormulaU = "1"
    Application.ActiveWindow.Page.Shapes.ItemFromID(id).CellsSRC(visSectionObject, visRowGradientProperties, visFillGradientEnabled).FormulaU = "FALSE"
    Application.ActiveWindow.Page.Shapes.ItemFromID(id).CellsSRC(visSectionObject, visRowGradientProperties, visRotateGradientWithShape).FormulaU = "FALSE"

End Sub
