#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
#
#
# This is symptom checker chat-bot like demo application by EndlessMedical.com API, Lukasz Kiljanek MD
# It is far from perfect demo app to showcase the API.
# By downloading, using, editing this file, you agree to fully comply with terms of use as listed on
# https://endlessmedical.com/termsofuse/
#
# If you can't or do not want to comply with this terms of use please remove this file immediately.'
#
# Use it at your own risk with full compliance to terms of use.
# Endless Medical does not provide any warranties, implied or discrete.
# Do not use EndlessMedical API as medical provider, or as medical diagnosis tool.
# All symptom checkers created based on this source code or using EndlessMedicalAPI have to include information that:
# The symptom checker can not be used if it is to delay seekinf for proper care and medical attention.
# The symptom checker is not a medical provider.
# The user of the symptom checker has to consent to the terms of use @ https://endlessmedical.com/termsofuse/
#

# All symptom checkers need to be reported to and registered with lukaszkiljanekem@gmail.com, to so we can maitain contact.



# By using this code you agree to not collect, use, copy or reproduce any HIPAA protected information.
#
#
#  No comments provided, I am sorry at this point I have no time for this, but I am sure anyone truly interested shall be able to
#  follow the code.
#  All copyrights of respected owners have to be preserved by users of this code.

#  Copyright (c) 2021 Lukasz Kiljanek, EndlessMedical, EndlessMedical.com
#
#   Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
#   The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


library(shiny)
library(shinyjs)
library(dplyr, warn.conflicts = FALSE)
library(shinyWidgets)
library(vov)
library(shinyanimate)
# Define UI for application that draws a histogram
shinyUI(
  bootstrapPage(
    theme = "bootstrap1-paper.css",
    
    
    
    absolutePanel(
      id = "Powered",
      style = "  height: 27px;     line-height: 23px;width: 232px;    " ,
      
      
      
      
      
      #animate = "fade",
      fixed = TRUE,
      align = "center",
      valign = "top",
      bottom  = "15px",
      left = "10px",
      
      position = "fixed",
      
      style = "background-color:#ffffffbb; border-radius:20px;  color:black; z-index:31; opacity:1; overflow-x: hidden;  overflow-y: hidden;  "     ,
      draggable = FALSE,
      
      HTML(
        "  <a href='http://www.endlessmedical.com' style='color:#000000;' target='_blank' ><p align='center '; style='text-align: center; '><b>
         Powered by EndlessMedical.com</a> </b></p>


        <img src='logobluetrans.png'  width='20px' style='margin-left: 0px; align:right; float:right; position: relative;
    top: -32px;
    left: -212px;
'>


        "
        
        
        
        
        
      )
    ),
    # absolutePanel(
    #   id = "SessionIDPanel",
    #   style = "  height: 27px;     line-height: 23px;width: 532px;    " ,
    #   
    #   
    #   
    #   
    #   
    #   #animate = "fade",
    #   fixed = TRUE,
    #   align = "center",
    #   valign = "top",
    #   bottom = "10px",
    #   left = "5px",
    #   
    #   position = "fixed",
    #   
    #   style = "background-color:#ffffffbb; border-radius:20px;  color:black; z-index:31; opacity:1; overflow-x: hidden;  overflow-y: hidden;  "     ,
    #   draggable = FALSE,
    #   
    #    HTML( " ")
    #   #   
    #   #   paste0(
    #   #     "<left><a href='https://api.endlessmedical.com/v1/dx/GetMedicalDocumentation?SessionID=",SessionIDCurrent)),
    #   # 
    #   # HTML(
    #   #   paste0("' style='color:#000000;' target='_blank' ><p align='center '; style='text-align: center; '>
    #   #                  <b>Click on or share this <u>link</u> with your provider for readable note with your answers.</b>")),HTML("</a><br><br>
    #   #                  
    #   #                  
    #                 
    #                 
    #                 
    # 
    #            
    #                 
    #                 
    #   
    #   
    #   
    #   
    # 
    # ),
    
    
    
    
    useShinyjs(),
    use_vov(),
    withAnim(),
    # Application title
    
    
    
    shinyjs::useShinyjs(),
    
    tags$head(
      HTML(
        "
      <!-- Global site tag (gtag.js) - Google Analytics -->
        <script async src='https://www.googletagmanager.com/gtag/js?id=UA-151880879-2'></script>
        <script>
        window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());

      gtag('config', 'UA-151880879-2');
      </script>
        "
      ),
      
      
      tags$style(
        HTML(
          "
:root {
  --animate-duration: 800ms;
          }
.btn-lg {


    border-radius: 20px 20px 20px 20px;
}

.btn {
  white-space: normal;

  text-transform: none;
  margin-bottom: 0px;


    border-radius: 20px;
  padding: 12px 15px 12px 17px;
  margin-top: 2px;
  margin-bottom: 2px;
  font-weight: 400;
  display: inline-block;
   font-size:15px;
   line-height: 1.25;
border-radius: 20px 20px 20px 20px;
  -webkit-box-shadow:none;
  box-shadow:none;

    border-radius: 20px 20px 20px 20px;

                border-top-style: dashed;
    border-top-color:#0000002E;
    border-top-width: 0.7px;


}

.btn-group-lg
{
border-radius: 20px 20px 20px 20px;
   box-shadow:none;
    border-radius: 20px 20px 20px 20px;

  }

.btn-primary {
background: rgb(0, 120, 254)
}

.btn-block {
  white-space: normal;
  margin-bottom: 0px;
  display: inline-grid;
  width : 100%;
    text-transform: none;


}
.btn-group-vertical {
position: relative;
    float: none;
      width : 90%;
        text-transform: none;

        border-top: 1px solid rgba(0, 0, 0, 0.3);

  color: white;
  margin-right: 2px;
  margin-bottom: 20px;
  background: rgb(0, 120, 254);
  position: relative;
  box-shadow:none;


}


.btn-group-vertica[disabled] {
    background-color:  rgb(0, 120, 254);
}

.btn-group-container-sw
{
background: white;
  align-items: flex-end;

  color: white;
  margin-left: 0%;

    margin-right: 0px;
  margin-bottom: -17px;
  position: relative;
    box-shadow:none;

}




.btn-group-container-sw:before {
  content: '';
  position: absolute;
  z-index: 0;
  bottom: 0;
  right: -8px;
  height: 20px;
  width: 20px;
  background: rgb(0, 120, 254);
  border-bottom-left-radius: 15px;
}

.btn-group-container-sw:after {
  content: '';
  position: absolute;
  z-index: 1;
  bottom: 0;
  right: -10px;
  width: 10px;
  height: 20px;
  background: white;
  border-bottom-left-radius: 10px;
}




        body {
  font-family: roboto, helvetica;
  display: flex ;
  flex-direction: column;
  align-items: center;


font-family: roboto, helvetica;

background-color:#ffffffff;
background-size:cover;
background-repeat:no-repeat;
background-positi
on: center;
background-attachment: fixed;
 overflow-x: hidden;
}





.chat {


  display: flex;
  flex-direction: column;
  padding: 0px;
}

.messages {
  margin-top: 12px;
  display: flex;
  flex-direction: column;
}

.message {
  border-radius: 20px;
  padding: 10px 12px 10px 13px;
  margin-top: 0px;
  margin-bottom: -5px;
  font-weight: 400;
  display: inline-block;
   font-size:15px;
   line-height: 1.2;
   width: 100%;
}

.yours {
  align-items: flex-start;
}

.yours .message {

  margin-left: 28px;

  background-color: #EEE;
  position: relative;
}

.yours .message.last:before {
  content: '';

  position: absolute;
  z-index: 0;
  bottom: 0;
  left: -7px;
  height: 20px;
  width: 20px;
  background: #EEE;
  border-bottom-right-radius: 15px;
}
.yours .message.last:after {
  content: '';
  position: absolute;
  z-index: 1;
  bottom: 0;
  left: -10px;
  width: 10px;
  height: 20px;
  background: white;
  border-bottom-right-radius: 10px;
}

.mine {
  align-items: flex-end;
}

.mine .message {
  color: white;
  margin-left: 0%;

  background: rgb(0, 120, 254);
  position: relative;
}

.mine .message.last:before {
  content: '';
  position: absolute;
  z-index: 0;
  bottom: 0;
  right: -8px;
  height: 20px;
  width: 20px;
  background: rgb(0, 120, 254);
  border-bottom-left-radius: 15px;
}

.mine .message.last:after {
  content: '';
  position: absolute;
  z-index: 1;
  bottom: 0;
  right: -10px;
  width: 10px;
  height: 20px;
  background: white;
  border-bottom-left-radius: 10px;
}



          ")
      )
    ),
    
    conditionalPanel(
      condition = "$('html').hasClass('shiny-busy')",
      absolutePanel(
        id = "OnLoadIcon",
        fixed = TRUE,
        align = "center",
        top = "50%",
        #left = "611px",
        #right = "611px",
        position = "fixed",
        style = "background-color:white; text-align:center; color:.blue; z-index:31; opacity:0;",
        draggable = FALSE,
        #  icon("refresh fa-spin fa-4x", lib = "font-awesome" , style = "opacity:0.2;")
      )
    ),
    
    
    #
    #     fluidRow(column(style="    height: 50px;",
    #       12,
    #       HTML(
    #         "  <a href='http://www.endlessmedical.com' style='color:#000000;' target='_blank' ><h6 align='center '; style='text-align: center; '>
    #          Powered by EndlessMedical.com</a> </h6>
    #
    #
    #         <img src='logobluetrans.png'  width='20px' style='margin-left: 0px; align:right; float:right; position: relative;
    #     top: -37px;
    #     left: -20px;
    # '>
    #
    #
    #         "
    #       )
    #     )),
    
    fluidRow(
      id = "bot1",
      style = "width:100%;",
      column(
        6,
        
        
        fade_in_left(
          div(class = "yours messages",
              div(
                class = "message",
               HTML(
               "
 
 
                     Hi, my name is Cruzbot, I am an artificial intelligence symptom checker. <br><br>
                     I can provide educational information on your symptoms, list diseases usually  associated with your symptoms, or provide medical specialties usually treating patients with the symptoms.<br><br>"
#                     Your Session ID is:<b>"),SessionIDCurrent,HTML("</b><br><br> <b>Anyone who can see this Session ID will know all your answers to all questions. </b><br><br>The Session ID does not, however store any protected health information like your indentity, name, IP address or zip code. </br></br>
#                     
#                     You can share the following link with your healthcare provider, so he can retrieve all your answers in readable form, and take it from where you finished. <br><br>
#                    
#                   ")
#                 ,
#                 HTML(
#                 
#                 paste0(
#                 "<left><a href='https://api.endlessmedical.com/v1/dx/GetMedicalDocumentation?SessionID=",SessionIDCurrent)),
#                 
#                 HTML(
#                 paste0("' style='color:#000000;' target='_blank' ><p align='center '; style='text-align: center; '>
#                        https://api.endlessmedical.com/v1/dx/GetMedicalDocumentation?SessionID=",SessionIDCurrent)),HTML("</a><br><br>
#                        
#                        
#                     
#                     
            #         
            #         
            #        
            #         
            #         
            # 
            # 
            # 
             
               )
              )),
          
          duration = 'faster',
          delay = 0,
          steps = 50,
          iteration = NULL
        )
        
      ),
      column(6)
    ),
    
    
    
    
    fluidRow(
      id = "bot3",
      style = "width:100%;",
      column(
        6,
        
        fade_in_left(
          div(class = "yours messages",
              div(
                class = "message last",
                HTML(
                  "



                          Please remember, I am not healthcare provider, so I cannot provide professional medical advice.     <br><br>



                                       In case of any symptoms, complaints or problems, always immediately seek medical advice appropriately and don't delay contacting professional healthcare services. Only after you contact healthcare profesional use this symptom checker.

                                           <br><br>Please read our terms of use of our services, which are available for read <a href=https://cruzmedika.com/general-terms-and-conditions/>here</a>

<img src='logobluetrans.png'  width='20px' style='margin-left: 0px; align:left; float:left; position: relative;
    top: 22px;
    left: -45px;
'>
                                                                                       "
                  
                  
                  
                )
              ))
          ,
          duration = 'faster',
          delay = 1,
          steps = 50,
          iteration = NULL
        )
        
      ),
      column(6)
    ),
    
    
    
    fluidRow(
      id = "bot6",
      style = "width:100%;",
      class = "container-fluid",
      
      column(
        6,
        
        uiOutput('stata'),
        #   br(),
        uiOutput('results'),
        #   br(),
        uiOutput('chronicresults'),
        uiOutput('specs'),
        #   br(),
                uiOutput('link'),
           br(),

        uiOutput('question')
      ),
      column(6)
    ),
    #    br(),
    
    fluidRow(
      id = "user1",
      class = "container-fluid",
      style = "width:100%;",
      column(6),
      column(
        style = "padding-right: 0px;",
        6,
        uiOutput('question2'),
        
        fade_in_right(
          radioGroupButtons(
            inputId = 'AcceptRadio',
            label = '',
            direction = 'vertical',
            
            
            width = '100%',
            size = 'lg',
            choiceNames  = c('I have read and I accept the terms.', 'I do not accept the terms.'),
            choiceValues = c(1, 2),
            choices = NULL,
            selected = '',
            individual = FALSE,
            justified = TRUE,
            
            status = 'primary',
            checkIcon = list(yes = icon("ok",
                                        lib = "glyphicon"))
          )
          ,
          duration = 'faster',
          delay = 2,
          steps = 50,
          iteration = NULL
        )
        
        
        
      )
      
      
      
    ),
    
    
    fluidRow(
      id = "user2",
      class = "container-fluid",
      style = "width:100%;",
      column(6),
      column(
        style = "padding-right: 0px;",
        6,
        
        
        
        uiOutput('answers'),
        uiOutput('answersgenderage'),
        uiOutput('skip'),
        uiOutput('done')
        
      )
      
      
      
    ),
    
    
    
    
    
    
    
    
    
    HTML("


             <br> <br><br><br><br> ")
    
    
    ,
    
    
    
    conditionalPanel(
      condition = "$('html').hasClass('shiny-busy')",
      
      absolutePanel(
        style = "  height: 72px;     line-height: 63px;width: 72px;    left: 50%;
    transform: translateX(-50%) translateY(-50%);" ,
        
        id = "BusyIndicator",
        
        
        
        #animate = "fade",
        fixed = TRUE,
        align = "center",
        top = "30%",
        
        position = "fixed",
        
        style = "background-color:#ffffff00; text-align:center; color:black; z-index:31; opacity:0.2; overflow-x: hidden;  overflow-y: hidden;  padding-top: 10px;"     ,
        draggable = FALSE,
        icon("refresh fa-spin fa-4x", lib = "font-awesome"),
      )
    )
    
    
    
    
    
    
    
    
  )
)