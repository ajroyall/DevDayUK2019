      $set sourceformat(variable)

      *> Namespace: AmortWPFClient

      *>> <summary>
      *>> App
      *>> </summary>
       class-id AmortWPFClient.App is partial inherits type System.Windows.Application.

       working-storage section.

      *>> <summary>
      *>> Application Entry Point.
      *>> </summary>
       method-id Main static final
                    attribute System.STAThread()
                    attribute System.Diagnostics.DebuggerNonUserCode()
                    attribute System.CodeDom.Compiler.GeneratedCode("PresentationBuildTasks", "4.0.0.0").
       local-storage section.
       01 app type AmortWPFClient.App.
       procedure division.
       set app to new AmortWPFClient.App
       invoke app::InitializeComponent
       invoke app::Run
       end method.

      *>> <summary>
      *>> InitializeComponent
      *>> </summary>
       method-id InitializeComponent final
                    attribute System.Diagnostics.DebuggerNonUserCode()
                    attribute System.CodeDom.Compiler.GeneratedCode("PresentationBuildTasks", "4.0.0.0").
       procedure division.
      $line 4 "..\..\App.xaml"
       set self::StartupUri to new System.Uri("Window1.xaml" type System.UriKind::Relative)
      $line default
      $line hidden
       end method.

       end class.

