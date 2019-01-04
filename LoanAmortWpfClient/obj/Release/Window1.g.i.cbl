      $set sourceformat(variable)

      *> Namespace: AmortWPFClient

      *>> <summary>
      *>> Window1
      *>> </summary>
       class-id AmortWPFClient.Window1 is partial inherits type System.Windows.Window
       implements type System.Windows.Markup.IComponentConnector.

       working-storage section.
      $line 6 "..\..\Window1.xaml"
       01 btnAmort type System.Windows.Controls.Button internal
           attribute System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields").
      $line default
      $line hidden
      $line 7 "..\..\Window1.xaml"
       01 tbPrincipal type System.Windows.Controls.TextBox internal
           attribute System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields").
      $line default
      $line hidden
      $line 8 "..\..\Window1.xaml"
       01 tbMonths type System.Windows.Controls.TextBox internal
           attribute System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields").
      $line default
      $line hidden
      $line 9 "..\..\Window1.xaml"
       01 tbRate type System.Windows.Controls.TextBox internal
           attribute System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields").
      $line default
      $line hidden
      $line 10 "..\..\Window1.xaml"
       01 dgAmortdata type System.Windows.Controls.DataGrid internal
           attribute System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields").
      $line default
      $line hidden
      $line 19 "..\..\Window1.xaml"
       01 btnAmortString type System.Windows.Controls.Button internal
           attribute System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields").
      $line default
      $line hidden
      $line 20 "..\..\Window1.xaml"
       01 label_Principal type System.Windows.Controls.Label internal
           attribute System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields").
      $line default
      $line hidden
      $line 21 "..\..\Window1.xaml"
       01 label_Copy type System.Windows.Controls.Label internal
           attribute System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields").
      $line default
      $line hidden
      $line 22 "..\..\Window1.xaml"
       01 label_Copy1 type System.Windows.Controls.Label internal
           attribute System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields").
      $line default
      $line hidden
      $line 23 "..\..\Window1.xaml"
       01 lblInterest type System.Windows.Controls.Label internal
           attribute System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields").
      $line default
      $line hidden
      $line 24 "..\..\Window1.xaml"
       01 lblTotInterest type System.Windows.Controls.Label internal
           attribute System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1823:AvoidUnusedPrivateFields").
      $line default
      $line hidden
       01 _contentLoaded condition-value.

      *>> <summary>
      *>> InitializeComponent
      *>> </summary>
       method-id InitializeComponent final
                    attribute System.Diagnostics.DebuggerNonUserCode()
                    attribute System.CodeDom.Compiler.GeneratedCode("PresentationBuildTasks", "4.0.0.0").
       local-storage section.
       01 resourceLocater type System.Uri.
       procedure division.
       if _contentLoaded then 
           goback
       end-if
       set _contentLoaded to True
       set resourceLocater to new System.Uri("/LoanAmortWpfClient;component/window1.xaml" type System.UriKind::Relative)
      $line 1 "..\..\Window1.xaml"
       invoke type System.Windows.Application::LoadComponent(self resourceLocater)
      $line default
      $line hidden
       end method.

       method-id Connect final for type System.Windows.Markup.IComponentConnector
                    attribute System.Diagnostics.DebuggerNonUserCode()
                    attribute System.CodeDom.Compiler.GeneratedCode("PresentationBuildTasks", "4.0.0.0")
                    attribute System.ComponentModel.EditorBrowsable(
                      type System.ComponentModel.EditorBrowsableState::Never)
                    attribute System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", 
                      "CA1033:InterfaceMethodsShouldBeCallableByChildTypes")
                    attribute System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Maintainability", 
                      "CA1502:AvoidExcessiveComplexity")
                    attribute System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", 
                      "CA1800:DoNotCastUnnecessarily").
       procedure division using by value connectionId as binary-long target as object.
       if connectionId = 1 then 
           set btnAmort to target as type System.Windows.Controls.Button
      $line 6 "..\..\Window1.xaml"
           invoke btnAmort::add_Click(new System.Windows.RoutedEventHandler(self::btnAmort_Click))
      $line default
      $line hidden
           goback
       end-if
       if connectionId = 2 then 
           set tbPrincipal to target as type System.Windows.Controls.TextBox
           goback
       end-if
       if connectionId = 3 then 
           set tbMonths to target as type System.Windows.Controls.TextBox
           goback
       end-if
       if connectionId = 4 then 
           set tbRate to target as type System.Windows.Controls.TextBox
           goback
       end-if
       if connectionId = 5 then 
           set dgAmortdata to target as type System.Windows.Controls.DataGrid
           goback
       end-if
       if connectionId = 6 then 
           set btnAmortString to target as type System.Windows.Controls.Button
      $line 19 "..\..\Window1.xaml"
           invoke btnAmortString::add_Click(new System.Windows.RoutedEventHandler(self::btnAmortString_Click))
      $line default
      $line hidden
           goback
       end-if
       if connectionId = 7 then 
           set label_Principal to target as type System.Windows.Controls.Label
           goback
       end-if
       if connectionId = 8 then 
           set label_Copy to target as type System.Windows.Controls.Label
           goback
       end-if
       if connectionId = 9 then 
           set label_Copy1 to target as type System.Windows.Controls.Label
           goback
       end-if
       if connectionId = 10 then 
           set lblInterest to target as type System.Windows.Controls.Label
           goback
       end-if
       if connectionId = 11 then 
           set lblTotInterest to target as type System.Windows.Controls.Label
           goback
       end-if
       set _contentLoaded to True
       end method.

       end class.

