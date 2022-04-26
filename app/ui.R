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
    
    
    wellPanel(
      div(style='display:flex; justify-content:space-around;width:100vw;',
        h5("Maximum number of Questions to answer (the more questions, the more precision for the diagnosis)"),
        numericInput('numx',label = NULL,width = '70px',value = 5)
      ),
      div(style='width:100vw; padding: 0 1.75vw;',
        "IMPORTANT. Please note that if our bot detects inconsistent responses, there will no further questions to ask to conclude with a preliminary diagnosis. In such a case, please refresh the screen and start over.
",
        p("")
      ),
      div(style='display:flex; justify-content:space-around;width:100vw;',
        tags$div(id="google_translate_element")
      ),
        ),
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
 <script type='text/javascript'>
function googleTranslateElementInit() {
  new google.translate.TranslateElement({pageLanguage: 'en', layout: google.translate.TranslateElement.InlineLayout.VERTICAL}, 'google_translate_element');
}
</script>

<script type='text/javascript' src='//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit'></script>
  

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
background: #DD1010;
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



##############
/* Copyright 2021 Google Inc. All Rights Reserved. */
.goog-te-banner-frame{left:0px;top:0px;height:39px;width:100%;z-index:10000001;position:fixed;border:none;border-bottom:1px solid #6b90da;margin:0;-moz-box-shadow:0 0 8px 1px #999999;-webkit-box-shadow:0 0 8px 1px #999999;box-shadow:0 0 8px 1px #999999;_position:absolute}.goog-te-menu-frame{z-index:10000002;position:fixed;border:none;-moz-box-shadow:0 3px 8px 2px #999999;-webkit-box-shadow:0 3px 8px 2px #999999;box-shadow:0 3px 8px 2px #999999;_position:absolute}.goog-te-ftab-frame{z-index:10000000;border:none;margin:0}.goog-te-gadget{font-family:arial;font-size:11px;color:#666;white-space:nowrap}.goog-te-gadget img{vertical-align:middle;border:none}.goog-te-gadget-simple{background-color:#fff;border-left:1px solid #d5d5d5;border-top:1px solid #9b9b9b;border-bottom:1px solid #e8e8e8;border-right:1px solid #d5d5d5;font-size:10pt;display:inline-block;padding-top:1px;padding-bottom:2px;cursor:pointer;zoom:1;*display:inline}.goog-te-gadget-icon{margin-left:2px;margin-right:2px;width:19px;height:19px;border:none;vertical-align:middle}.goog-te-combo{margin-left:4px;margin-right:4px;vertical-align:baseline;*vertical-align:middle}.goog-te-gadget .goog-te-combo{margin:4px 0}.goog-logo-link,.goog-logo-link:link,.goog-logo-link:visited,.goog-logo-link:hover,.goog-logo-link:active{font-size:12px;font-weight:bold;color:#444;text-decoration:none}.goog-te-banner .goog-logo-link,.goog-close-link{display:block;margin:0px 10px}.goog-te-banner .goog-logo-link{padding-top:2px;padding-left:4px}.goog-te-combo,.goog-te-banner *,.goog-te-ftab *,.goog-te-menu *,.goog-te-menu2 *,.goog-te-balloon *{font-family:arial;font-size:10pt}.goog-te-banner{margin:0;background-color:#e4effb;overflow:hidden}.goog-te-banner img{border:none}.goog-te-banner-content{color:#000}.goog-te-banner-content img{vertical-align:middle}.goog-te-banner-info{color:#666;vertical-align:top;margin-top:0px;font-size:7pt}.goog-te-banner-margin{width:8px}.goog-te-button{border-color:#e7e7e7;border-style:none solid solid none;border-width:0 1px 1px 0}.goog-te-button div{border-color:#cccccc #999999 #999999 #cccccc;border-right:1px solid #999999;border-style:solid;border-width:1px;height:20px}.goog-te-button button{background:transparent;border:none;cursor:pointer;height:20px;overflow:hidden;margin:0;vertical-align:top;white-space:nowrap}.goog-te-button button:active{background:none repeat scroll 0 0 #cccccc}.goog-te-ftab{margin:0px;background-color:#fff;white-space:nowrap}.goog-te-ftab-link{text-decoration:none;font-weight:bold;font-size:10pt;border:1px outset #888;padding:6px 10px;white-space:nowrap;position:absolute;left:0px;top:0px}.goog-te-ftab-link img{margin-left:2px;margin-right:2px;width:19px;height:19px;border:none;vertical-align:middle}.goog-te-ftab-link span{text-decoration:underline;margin-left:2px;margin-right:2px;vertical-align:middle}.goog-float-top .goog-te-ftab-link{padding:2px 2px;border-top-width:0px}.goog-float-bottom .goog-te-ftab-link{padding:2px 2px;border-bottom-width:0px}.goog-te-menu-value{text-decoration:none;color:#0000cc;white-space:nowrap;margin-left:4px;margin-right:4px}.goog-te-menu-value span{text-decoration:underline}.goog-te-menu-value img{margin-left:2px;margin-right:2px}.goog-te-gadget-simple .goog-te-menu-value{color:#000}.goog-te-gadget-simple .goog-te-menu-value span{text-decoration:none}.goog-te-menu{background-color:#ffffff;text-decoration:none;border:2px solid #c3d9ff;overflow-y:scroll;overflow-x:hidden;position:absolute;left:0;top:0}.goog-te-menu-item{padding:3px;text-decoration:none}.goog-te-menu-item,.goog-te-menu-item:link{color:#0000cc;background:#ffffff}.goog-te-menu-item:visited{color:#551a8b}.goog-te-menu-item:hover{background:#c3d9ff}.goog-te-menu-item:active{color:#0000cc}.goog-te-menu2{background-color:#ffffff;text-decoration:none;border:1px solid #6b90da;overflow:hidden;padding:4px}.goog-te-menu2-colpad{width:16px}.goog-te-menu2-separator{margin:6px 0;height:1px;background-color:#aaa;overflow:hidden}.goog-te-menu2-item div,.goog-te-menu2-item-selected div{padding:4px}.goog-te-menu2-item .indicator{display:none}.goog-te-menu2-item-selected .indicator{display:auto}.goog-te-menu2-item-selected .text{padding-left:4px;padding-right:4px}.goog-te-menu2-item,.goog-te-menu2-item-selected{text-decoration:none}.goog-te-menu2-item div,.goog-te-menu2-item:link div,.goog-te-menu2-item:visited div,.goog-te-menu2-item:active div{color:#0000cc;background:#ffffff}.goog-te-menu2-item:hover div{color:#ffffff;background:#3366cc}.goog-te-menu2-item-selected div,.goog-te-menu2-item-selected:link div,.goog-te-menu2-item-selected:visited div,.goog-te-menu2-item-selected:hover div,.goog-te-menu2-item-selected:active div{color:#000;font-weight:bold}.goog-te-balloon{background-color:#ffffff;overflow:hidden;padding:8px;border:none;-moz-border-radius:10px;border-radius:10px}.goog-te-balloon-frame{background-color:#ffffff;border:1px solid #6b90da;-moz-box-shadow:0 3px 8px 2px #999999;-webkit-box-shadow:0 3px 8px 2px #999999;box-shadow:0 3px 8px 2px #999999;-moz-border-radius:8px;border-radius:8px}.goog-te-balloon img{border:none}.goog-te-balloon-text{margin-top:6px}.goog-te-balloon-zippy{margin-top:6px;white-space:nowrap}.goog-te-balloon-zippy *{vertical-align:middle}.goog-te-balloon-zippy .minus{background-image:url(//www.google.com/images/zippy_minus_sm.gif)}.goog-te-balloon-zippy .plus{background-image:url(//www.google.com/images/zippy_plus_sm.gif)}.goog-te-balloon-zippy span{color:#00c;text-decoration:underline;cursor:pointer;margin:0 4px}.goog-te-balloon-form{margin:6px 0 0 0}.goog-te-balloon-form form{margin:0}.goog-te-balloon-form form textarea{margin-bottom:4px;width:100%}.goog-te-balloon-footer{margin:6px 0 4px 0}.goog-te-spinner-pos{z-index:1000;position:fixed;transition-delay:0.6s;left:-1000px;top:-1000px}.goog-te-spinner-animation{background:#ccc;display:flex;align-items:center;justify-content:center;width:104px;height:104px;border-radius:50px;background:#fff url(//www.gstatic.com/images/branding/product/2x/translate_24dp.png) 50% 50% no-repeat;transition:all 0.6s ease-in-out;transform:scale(0.4);opacity:0}.goog-te-spinner-animation-show{transform:scale(0.5);opacity:1}.goog-te-spinner{margin:2px 0 0 2px;animation:goog-te-spinner-rotator 1.4s linear infinite}@keyframes goog-te-spinner-rotator{0%{transform:rotate(0deg)}100%{transform:rotate(270deg)}}.goog-te-spinner-path{stroke-dasharray:187;stroke-dashoffset:0;stroke:#4285f4;transform-origin:center;animation:goog-te-spinner-dash 1.4s ease-in-out infinite}@keyframes goog-te-spinner-dash{0%{stroke-dashoffset:187}50%{stroke-dashoffset:46.75;transform:rotate(135deg)}100%{stroke-dashoffset:187;transform:rotate(450deg)}}#goog-gt-tt html,#goog-gt-tt body,#goog-gt-tt div,#goog-gt-tt span,#goog-gt-tt iframe,#goog-gt-tt h1,#goog-gt-tt h2,#goog-gt-tt h3,#goog-gt-tt h4,#goog-gt-tt h5,#goog-gt-tt h6,#goog-gt-tt p,#goog-gt-tt a,#goog-gt-tt img,#goog-gt-tt ol,#goog-gt-tt ul,#goog-gt-tt li,#goog-gt-tt table,#goog-gt-tt form,#goog-gt-tt tbody,#goog-gt-tt tr,#goog-gt-tt td{margin:0;padding:0;border:0;font-size:100%;font:inherit;vertical-align:baseline;text-align:left;line-height:normal}#goog-gt-tt ol,#goog-gt-tt ul{list-style:none}#goog-gt-tt table{border-collapse:collapse;border-spacing:0}#goog-gt-tt caption,#goog-gt-tt th,#goog-gt-tt td{text-align:left;font-weight:normal}#goog-gt-tt input::-moz-focus-inner{border:0}div#goog-gt-tt{padding:10px 14px}#goog-gt-tt{color:#222;background-color:#ffffff;border:1px solid #eee;box-shadow:0 4px 16px rgba(0,0,0,.2);-moz-box-shadow:0 4px 16px rgba(0,0,0,.2);-webkit-box-shadow:0 4px 16px rgba(0,0,0,.2);display:none;font-family:arial;font-size:10pt;width:420px;padding:12px;position:absolute;z-index:10000}#goog-gt-tt .original-text,.gt-hl-layer{clear:both;font-size:10pt;position:relative;text-align:justify;width:100%}#goog-gt-tt .title{color:#999;font-family:arial,sans-serif;margin:4px 0;text-align:left}#goog-gt-tt .close-button{display:none}#goog-gt-tt .logo{float:left;margin:0px}#goog-gt-tt .activity-links{display:inline-block}#goog-gt-tt .started-activity-container{display:none;width:100%}#goog-gt-tt .activity-root{margin-top:20px}#goog-gt-tt .left{float:left}#goog-gt-tt .right{float:right}#goog-gt-tt .bottom{min-height:15px;position:relative;height:1%}#goog-gt-tt .status-message{background:-moz-linear-gradient(top,#29910d 0%,#20af0e 100%);background:-webkit-linear-gradient(top,#29910d 0%,#20af0e 100%);background:-o-linear-gradient(top,#29910d 0%,#20af0e 100%);background:-ms-linear-gradient(top,#29910d 0%,#20af0e 100%);background:linear-gradient(top,#29910d 0%,#20af0e 100%);background:#29910d;border-radius:4px;-moz-border-radius:4px;-webkit-border-radius:4px;box-shadow:inset 0px 2px 2px #1e6609;-moz-box-shadow:inset 0px 2px 2px #1e6609;-webkit-box-shadow:inset 0px 2px 2px #1e6609;color:white;font-size:9pt;font-weight:bolder;margin-top:12px;padding:6px;text-shadow:1px 1px 1px #1e6609}#goog-gt-tt .activity-link{color:#1155cc;cursor:pointer;font-family:arial;font-size:11px;margin-right:15px;text-decoration:none}#goog-gt-tt textarea{font-family:arial;resize:vertical;width:100%;margin-bottom:10px;-webkit-border-radius:1px;-moz-border-radius:1px;border-radius:1px;border:1px solid #d9d9d9;border-top:1px solid silver;font-size:13px;height:auto;overflow-y:auto;padding:1px}#goog-gt-tt textarea:focus{-webkit-box-shadow:inset 0 1px 2px rgba(0,0,0,0.3);-moz-box-shadow:inset 0 1px 2px rgba(0,0,0,0.3);box-shadow:inset 0 1px 2px rgba(0,0,0,0.3);border:1px solid #4d90fe;outline:none}#goog-gt-tt .activity-cancel{margin-right:10px}#goog-gt-tt .translate-form{min-height:25px;vertical-align:middle;padding-top:8px}#goog-gt-tt .translate-form .activity-form{margin-bottom:5px;margin-bottom:0px}#goog-gt-tt .translate-form .activity-form input{display:inline-block;min-width:54px;*min-width:70px;border:1px solid #dcdcdc;border:1px solid rgba(0,0,0,0.1);text-align:center;color:#444;font-size:11px;font-weight:bold;height:27px;outline:0;padding:0 8px;vertical-align:middle;line-height:27px;margin:0 16px 0 0;box-shadow:0 1px 2px rgba(0,0,0,.1);-moz-box-shadow:0 1px 2px rgba(0,0,0,.1);-webkit-box-shadow:0 1px 2px rgba(0,0,0,.1);-webkit-border-radius:2px;-moz-border-radius:2px;border-radius:2px;-webkit-transition:all 0.218s;-moz-transition:all 0.218s;-o-transition:all 0.218s;transition:all 0.218s;background-color:#f5f5f5;background-image:-webkit-gradient(linear,left top,left bottom,from(#f5f5f5),to(#f1f1f1));background-image:-webkit-linear-gradient(top,#f5f5f5,#f1f1f1);background-image:-moz-linear-gradient(top,#f5f5f5,#f1f1f1);background-image:-ms-linear-gradient(top,#f5f5f5,#f1f1f1);background-image:-o-linear-gradient(top,#f5f5f5,#f1f1f1);background-image:linear-gradient(top,#f5f5f5,#f1f1f1);-webkit-user-select:none;-moz-user-select:none;cursor:default}#goog-gt-tt .translate-form .activity-form input:hover{border:1px solid #c6c6c6;color:#222;-webkit-transition:all 0.0s;-moz-transition:all 0.0s;-o-transition:all 0.0s;transition:all 0.0s;background-color:#f8f8f8;background-image:-webkit-gradient(linear,left top,left bottom,from(#f8f8f8),to(#f1f1f1));background-image:-webkit-linear-gradient(top,#f8f8f8,#f1f1f1);background-image:-moz-linear-gradient(top,#f8f8f8,#f1f1f1);background-image:-ms-linear-gradient(top,#f8f8f8,#f1f1f1);background-image:-o-linear-gradient(top,#f8f8f8,#f1f1f1);background-image:linear-gradient(top,#f8f8f8,#f1f1f1)}#goog-gt-tt .translate-form .activity-form input:active{border:1px solid #c6c6c6;color:#333;background-color:#f6f6f6;background-image:-webkit-gradient(linear,left top,left bottom,from(#f6f6f6),to(#f1f1f1));background-image:-webkit-linear-gradient(top,#f6f6f6,#f1f1f1);background-image:-moz-linear-gradient(top,#f6f6f6,#f1f1f1);background-image:-ms-linear-gradient(top,#f6f6f6,#f1f1f1);background-image:-o-linear-gradient(top,#f6f6f6,#f1f1f1);background-image:linear-gradient(top,#f6f6f6,#f1f1f1)}#goog-gt-tt .translate-form .activity-form input:focus #goog-gt-tt .translate-form .activity-form input.focus #goog-gt-tt .translate-form .activity-form input:active,#goog-gt-tt .translate-form .activity-form input:focus:active,#goog-gt-tt .translate-form .activity-form input:.focus:active{box-shadow:inset 0 0 0 1px rgba(255,255,255,0.5);-webkit-box-shadow:inset 0 0 0 1px rgba(255,255,255,0.5);-moz-box-shadow:inset 0 0 0 1px rgba(255,255,255,0.5)}#goog-gt-tt .translate-form .activity-form input:focus,#goog-gt-tt .translate-form .activity-form input.focus{outline:none;border:1px solid #4d90fe;z-index:4!important}#goog-gt-tt .translate-form .activity-form input.selected{background-color:#eeeeee;background-image:-webkit-gradient(linear,left top,left bottom,from(#eeeeee),to(#e0e0e0));background-image:-webkit-linear-gradient(top,#eeeeee,#e0e0e0);background-image:-moz-linear-gradient(top,#eeeeee,#e0e0e0);background-image:-ms-linear-gradient(top,#eeeeee,#e0e0e0);background-image:-o-linear-gradient(top,#eeeeee,#e0e0e0);background-image:linear-gradient(top,#eeeeee,#e0e0e0);-webkit-box-shadow:inset 0px 1px 2px rgba(0,0,0,0.1);-moz-box-shadow:inset 0px 1px 2px rgba(0,0,0,0.1);box-shadow:inset 0px 1px 2px rgba(0,0,0,0.1);border:1px solid #ccc;color:#333}#goog-gt-tt .translate-form .activity-form input.activity-submit{color:white;border-color:#3079ed;background-color:#4d90fe;background-image:-webkit-gradient(linear,left top,left bottom,from(#4d90fe),to(#4787ed));background-image:-webkit-linear-gradient(top,#4d90fe,#4787ed);background-image:-moz-linear-gradient(top,#4d90fe,#4787ed);background-image:-ms-linear-gradient(top,#4d90fe,#4787ed);background-image:-o-linear-gradient(top,#4d90fe,#4787ed);background-image:linear-gradient(top,#4d90fe,#4787ed)}#goog-gt-tt .translate-form .activity-form input.activity-submit:hover #goog-gt-tt .translate-form .activity-form input.activity-submit:focus,#goog-gt-tt .translate-form .activity-form input.activity-submit.focus #goog-gt-tt .translate-form .activity-form input.activity-submit:active{border-color:#3079ed;background-color:#357ae8;background-image:-webkit-gradient(linear,left top,left bottom,from(#4d90fe),to(#357ae8));background-image:-webkit-linear-gradient(top,#4d90fe,#357ae8);background-image:-moz-linear-gradient(top,#4d90fe,#357ae8);background-image:-ms-linear-gradient(top,#4d90fe,#357ae8);background-image:-o-linear-gradient(top,#4d90fe,#357ae8);background-image:linear-gradient(top,#4d90fe,#357ae8)}#goog-gt-tt .translate-form .activity-form input.activity-submit:hover{box-shadow:inset 0 0 0 1px #fff,0px 1px 1px rgba(0,0,0,0.1);-webkit-box-shadow:inset 0 0 0 1px #fff,0px 1px 1px rgba(0,0,0,0.1);-moz-box-shadow:inset 0 0 0 1px #fff,0px 1px 1px rgba(0,0,0,0.1)}#goog-gt-tt .translate-form .activity-form input:focus,#goog-gt-tt .translate-form .activity-form input.focus,#goog-gt-tt .translate-form .activity-form input:active,#goog-gt-tt .translate-form .activity-form input:hover,#goog-gt-tt .translate-form .activity-form input.activity-submit:focus,#goog-gt-tt .translate-form .activity-form input.activity-submit.focus,#goog-gt-tt .translate-form .activity-form input.activity-submit:active,#goog-gt-tt .translate-form .activity-form input.activity-submit:hover{border-color:#3079ed}#goog-gt-tt .gray{color:#999;font-family:arial,sans-serif}#goog-gt-tt .alt-helper-text{color:#999;font-size:11px;font-family:arial,sans-serif;margin:15px 0px 5px 0px}#goog-gt-tt .alt-error-text{color:#800;display:none;font-size:9pt}.goog-text-highlight{background-color:#c9d7f1;-webkit-box-shadow:2px 2px 4px #9999aa;-moz-box-shadow:2px 2px 4px #9999aa;box-shadow:2px 2px 4px #9999aa;box-sizing:border-box;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;position:relative}#goog-gt-tt .alt-menu.goog-menu{background:#ffffff;border:1px solid #dddddd;-webkit-box-shadow:0px 3px 3px #888;-moz-box-shadow:0px 2px 20px #888;box-shadow:0px 2px 4px #99a;min-width:0;outline:none;padding:0;position:absolute;z-index:2000}#goog-gt-tt .alt-menu .goog-menuitem{cursor:pointer;padding:2px 5px 5px;margin-right:0px;border-style:none}#goog-gt-tt .alt-menu div.goog-menuitem:hover{background:#ddd}#goog-gt-tt .alt-menu .goog-menuitem h1{font-size:100%;font-weight:bold;margin:4px 0px}#goog-gt-tt .alt-menu .goog-menuitem strong{color:#345aad}#goog-gt-tt .goog-submenu-arrow{text-align:right;position:absolute;right:0;left:auto}#goog-gt-tt .goog-menuitem-rtl .goog-submenu-arrow{text-align:left;position:absolute;left:0;right:auto}#goog-gt-tt .gt-hl-text,#goog-gt-tt .trans-target-highlight{background-color:#f1ea00;border-radius:4px;-webkit-border-radius:4px;-moz-border-radius:4px;-moz-box-shadow:rgba(0,0,0,.5) 3px 3px 4px;-webkit-box-shadow:rgba(0,0,0,.5) 3px 3px 4px;box-shadow:rgba(0,0,0,.5) 3px 3px 4px;box-sizing:border-box;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;color:#f1ea00;cursor:pointer;margin:-2px -2px -2px -3px;padding:2px 2px 2px 3px;position:relative}#goog-gt-tt .trans-target-highlight{color:#222}#goog-gt-tt .gt-hl-layer{color:white;position:absolute!important}#goog-gt-tt .trans-target,#goog-gt-tt .trans-target .trans-target-highlight{background-color:#c9d7f1;border-radius:4px 4px 0px 0px;-webkit-border-radius:4px 4px 0px 0px;-moz-border-radius:4px 4px 0px 0px;-moz-box-shadow:rgba(0,0,0,.5) 3px 3px 4px;-webkit-box-shadow:rgba(0,0,0,.5) 3px 3px 4px;box-shadow:rgba(0,0,0,.5) 3px 3px 4px;box-sizing:border-box;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;cursor:pointer;margin:-2px -2px -2px -3px;padding:2px 2px 3px 3px;position:relative}#goog-gt-tt span:focus{outline:none}#goog-gt-tt .trans-edit{background-color:transparent;border:1px solid #4d90fe;border-radius:0em;-webkit-border-radius:0em;-moz-border-radius:0em;margin:-2px;padding:1px}#goog-gt-tt .gt-trans-highlight-l{border-left:2px solid red;margin-left:-2px}#goog-gt-tt .gt-trans-highlight-r{border-right:2px solid red;margin-right:-2px}#goog-gt-tt #alt-input{padding:2px}#goog-gt-tt #alt-input-text{font-size:11px;padding:2px 2px 3px;margin:0;background-color:#fff;color:#333;border:1px solid #d9d9d9;border-top:1px solid #c0c0c0;display:inline-block;vertical-align:top;height:21px;box-sizing:border-box;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;-webkit-border-radius:1px}#goog-gt-tt #alt-input-text:hover{border:1px solid #b9b9b9;border-top:1px solid #a0a0a0;-webkit-box-shadow:inset 0px 1px 2px rgba(0,0,0,0.1);-moz-box-shadow:inset 0px 1px 2px rgba(0,0,0,0.1);box-shadow:inset 0px 1px 2px rgba(0,0,0,0.1)}#goog-gt-tt #alt-input-text:focus{-webkit-box-shadow:inset 0px 1px 2px rgba(0,0,0,0.3);-moz-box-shadow:inset 0px 1px 2px rgba(0,0,0,0.3);box-shadow:inset 0px 1px 2px rgba(0,0,0,0.3);outline:none;border:1px solid #4d90fe}#goog-gt-tt #alt-input-submit{font-size:11px;padding:2px 6px 3px;margin:0 0 0 2px;height:21px}

################

.btn-group-container-sw:before {
  content: '';
  position: absolute;
  z-index: 0;
  bottom: 0;
  right: -8px;
  height: 20px;
  width: 20px;
  background: #DD1010;
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


.goog-te-combo{
  padding:5px 15px;
border-radius:5px;
}

.goog-te-banner-frame{
  display:none !important;
}



        body {
  font-family: roboto, helvetica;
  display: flex ;
  flex-direction: column;
  align-items: center;
  top:0px !important;

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

                                           <br><br>Have you read and accept the terms of use of our Site and the manufacturer of the Chatbot, that are available to read at <a src=www.cruzmedika.com>www.cruzmedika.com</a> and <a src=Endlessmedical.com>Endlessmedical.com</a> respectively?

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