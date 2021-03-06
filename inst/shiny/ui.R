# Define UI for dataset viewer application
shinyUI(pageWithSidebar(
  # Application title
  headerPanel("Welcome to the NiLeDAM online application!"),

  sidebarPanel(
		h2("Data importation"),
    
		fileInput('file1', 'Choose CSV/TXT File',
		          accept=c('text/csv', 'text/comma-separated-values,text/plain')),
		tags$hr(),
		checkboxInput('header', ' Header?', TRUE),
    checkboxInput('rownames', ' Row names?', FALSE),
		selectInput('sep', 'Separator:', c(Comma=',',Semicolon=';',Tab='\t'),
                 'Comma'),
		selectInput('quote', 'Quote:',
                 c(None='','Double Quote'='"','Single Quote'="'"),
                 'Double Quote'),
		selectInput('dec', 'Decimal mark', c(Dot='.', Comma=','), 'Dot'),
 		br(),
 		h2("Age calculation"),
 		helpText(HTML("<strong>Note</strong>: When your dataset is properly
                   imported, go to the 'Ages' panel and choose the number of
                   bootstrap samples (increase it to 1000 for instance), run the
                   calculation and go to the 'Ages' panel. <strong>You have to
                   be patient</strong>, the computation time can be large.")),
		h2("Tests"),
    helpText(HTML("Once the ages calculated, the 'Test' panel is used to 
                  determine from which number of age population, the analyses
                  are coming.")),
		p(HTML("<div style='background-color:#FADDF2;border:1px solid black;'>This
           application is a graphical interface of the <a
           href='http://niledam.r-forge.r-project.org/'>NiLeDAM</a> package
           using the <a href='http://cran.univ-paris1.fr/'>R</a> software
           environment. If you have any trouble using it, please do not hesitate
           to contact <a mailto:'nathalie[AT]nathalievilla.org'>Nathalie 
           Villa-Vialaneix</a>, the package's maintainer.<br>
           The application scripts are available on GitHub:<br> 
           <code><font color='#870500'><b>git clone
           https://github.com/tuxette/niledam.git</b></font></code><br>and
           distributed <strong>without any guarantee</strong> under the licence
           <a href='http://cran.r-project.org/web/licenses/GPL-2'>GPL-2</a>.
           </div>")),
		p(HTML("")),
    p(HTML("<strong>If you are using the application for your publications,
           please
<a href='https://owncloud.nathalievilla.org/apps/files_sharing/get.php?token=2bd2782289949699ce4f8246dc2ef62363806cf2'>
           cite us</a>.</strong>"))
  ),

	mainPanel(
	  tabsetPanel(
	    tabPanel("Data",
	             h3("Basic user guide"),
	             p(HTML("To run the application, import your file with (U,Th,Pb)
                      contents and corresponding errors. This file must be a
                      text file having <strong>ONLY 6 columns</strong>: U, errU,
                      Th, ErrTh, Pb, ErrPb, in this order (with eventually a
                      first column containing the sample names). CSV format is
                      the easiest to use: such an example is given <a 
href='http://owncloud.nathalievilla.org/apps/files_sharing/get.php?token=51731049ed775fbe40746670171205596fff16f4'>
                      here</a> that is imported with the default parameters
                      specified on the left panel.<br>")),
	             p("Once your file's URL is pasted, the data are imported and if
                 the importation is done properly, the data are displayed on the
                 main panel. Then, you can perform the age calculation and the
                 tests by increasing the number of bootstrap samples."),
	             h3("The dataset you want to use is displayed below (only the
                  first 50 first lines if the dataset contains more than 50
                  lines):"),
	             tableOutput("view")
	    ),
      
	    tabPanel("Ages",
	             numericInput("boot", "Number of bootstrap samples (adviced:
                            1000):", 0),
	             numericInput("risk","Risk (%) for the confidence interval
                            (adviced: 5%):", 5),
	             numericInput("seed",
                            HTML("Set a random seed for reproducible results
                                 <a href='#pseudor'><sup>(1)</sup></a>:"),
	                          as.numeric(format(Sys.time(), "%M%S"))),  
               br(),br(),
               downloadButton('downloadAges', 'Download Ages'),br(),br(),
               tableOutput("ages"),
               p(HTML("<a name='pseudor'><sup>(1)</sup></a> The age estimation
                      is based on Monte Carlo method that uses randomness.
                      Setting a seed results in fixing the random procedure in
                      order to obtain reproducible results (runing several times
                      the process with the same random seed will give the same
                      ages). More information on pseudo-random generators at <a
href='http://en.wikipedia.org/wiki/Pseudorandom_number_generator'
                     >this link</a>."))),
      
	    tabPanel("Tests",
               helpText(HTML("Either supply 'nbmin' and 'nbmax' to find the
                             most probable age population number or set 'nbmax'
                             to 0 to perform a test for 'nbmin' age 
                             populations.")),
	             numericInput("nbmin", "Minimal number of populations tested:",1),
	             numericInput("nbmax","Maximal number of populations tested",0),
	             numericInput("level","Risk (%) for the confidence interval
                            (adviced: 5%):", 5),
               verbatimTextOutput("testres"),
               downloadButton('downloadPops', 'Download population numbers'),
               br(),br(),tableOutput("whichpop")),
	    
      tabPanel("Graphics",
               textInput("title","Title","Ages"),
               textInput("color","Color","red"),
               plotOutput("densities"))
	  )
	)
))
