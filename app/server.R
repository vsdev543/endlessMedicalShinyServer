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
# The symptom checker can not delay the seek for proper care.
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


library(renv)
library(shiny)
library(shinyjs)
library(httr)
library(rjson)
library(vov)
library(shinyanimate)
library(shinyWidgets)

IntentionQue <<- NULL
# HowManyQuestionsToAskBeforeShowingResults <<- 5


shinyServer(function(input, output, session) {
  HowManyQuestionsToAskBeforeShowingResults<-reactive({
    if(is.null(input$numx)){
      5
    }else{
      input$numx
    }
  })
  
  shinyjs::hide(
    "BusyIndicator",
    anim = TRUE,
    animType = "fade",
    time = 1
  )
  Submitted <<- FALSE
  answersProvided <<- NULL
  answersShownButNotPicked <<- NULL
  AllDiseasesList <<- fromJSON(file = 'DiseasesOutput.json')
  Diseases_Texts <<-
    unlist(lapply(AllDiseasesList, function(pred) {
      pred$text
    }))
  Diseases_LayTexts <<-
    unlist(lapply(AllDiseasesList, function(pred) {
      pred$laytext
    }))
  
  Diseases_Category <<-
    unlist(lapply(AllDiseasesList, function(pred) {
      pred$category
    }))
  Acute_Diseases_LayTextx<-Diseases_LayTexts[  Diseases_Category =="acute"]
  Chronic_Diseases_LayTextx<-Diseases_LayTexts[  Diseases_Category =="chronic"]
  
  
  names(Diseases_LayTexts) <- Diseases_Texts
  
  
  symptoms <<- fromJSON(file = 'SymptomsOutput.json')
  
  acceptedterms <<- 2
  FeaturesNames <<-
    lapply(symptoms, function(pred) {
      pred$name
    })
  LayQuestions <<- lapply(symptoms, function(pred) {
    pred$laytext
  })
  Choices <<- lapply(symptoms, function(pred) {
    pred$choices
  })
  FeatureType <<- lapply(symptoms, function(pred) {
    pred$type
  })
  ChoicesCounts <<-
    unlist(lapply(Choices, function(pred) {
      (length((pred)))
    }))
  ChoicesValues <<-
    lapply(Choices, function(pred) {
      (lapply (pred, function(result) {
        result$value
      }))
    })
  ChoicesLayTexts <<-
    lapply(Choices, function(pred) {
      (lapply (pred, function(result) {
        result$laytext
      }))
    })
  FeatureCategories <<-
    unlist(lapply(symptoms, function(pred) {
      pred$category
    }))
  
  SessionIDCurrent <<-
    fromJSON(rawToChar(
      GET("https://api.endlessmedical.com/v1/dx/InitSession")$content
    ))$SessionID
  res <-
    POST(
      'https://api.endlessmedical.com/v1/dx/AcceptTermsOfUse',
      query = list(passphrase = 'I have read, understood and I accept and agree to comply with the Terms of Use of EndlessMedicalAPI and Endless Medical services. The Terms of Use are available on endlessmedical.com',
                   SessionID = SessionIDCurrent)
    )
  res =  POST(
    'https://api.endlessmedical.com/v1/dx/SetUseDefaultValues',
    query = list(SessionID = SessionIDCurrent,
                 value = FALSE)
  )
  
  selectedMainSymptom <<- FALSE
  QuestionsToAskQue <<- c()
  Feature <<- NULL
  
  foundDiagnosis <<- FALSE
  SoFarFeatures <<- 0
  
  
  shinyjs::show(id = "Powered")
  
  
  observeEvent(input$AcceptRadio,
               {
                 if (input$AcceptRadio == 1)
                 {
                   
                   
                   
                   
                   shinyjs::hide(
                     id = "user1",
                     anim = TRUE,
                     animType = "fade",
                     time = 1
                   )
                   
                   shinyjs::hide(
                     id = "bot1",
                     anim = TRUE,
                     animType = "fade",
                     time = 1
                   )
                   shinyjs::hide(
                     id = "bot2",
                     anim = TRUE,
                     animType = "fade",
                     time = 1
                   )
                   shinyjs::hide(
                     id = "bot3",
                     anim = TRUE,
                     animType = "fade",
                     time = 1
                   )
                   shinyjs::hide(
                     id = "bot4",
                     anim = TRUE,
                     animType = "fade",
                     time = 1
                   )
                   shinyjs::hide(
                     id = "bot5",
                     anim = TRUE,
                     animType = "fade",
                     time = 1
                   )
                   
                   Sys.sleep(1.3)
                   shinyjs::show(id = "bot6")#,anim = TRUE, animType = "fade", time = 1)
                   shinyjs::show(id = "user2")#,anim = TRUE, animType = "fade", time = 1)
                   shinyjs::show(id = "question")#,anim = TRUE, animType = "fade", time = 1)
                   shinyjs::show(id = "answers")#,anim = TRUE, animType = "fade", time = 1)
                   
                   
                   output$question <- renderUI(fade_in_left({
                     (div(class = "yours messages",
                          div(
                            class = "message last",
                            HTML("Just as a starter, please pick your gender and age.")
                            ,
                            HTML(
                              "<img src='logobluetrans.png'  width='20px' style='margin-left: 0px; margin-right: 0px; margin-top: 0px;  margin-right: 0px; margin-top: 0px;  margin-right: 0px; margin-top: 0px; align:left; float:left; position: relative;
                            top: 22px;
                            left: -38px;

                              '>"
                            )
                          )))
                   },
                   duration = 'faster',
                   delay = 0,
                   steps = 50,
                   iteration = NULL))
                   
                   output$answersgenderage <- renderUI({
                     div(
                       fade_in_right(
                         (div (
                           radioGroupButtons(
                             inputId = 'AgeRadio',
                             label = '',
                             direction = 'vertical',
                             width = '100%',
                             size = 'lg',
                             choiceNames  = c(
                               '18-20 years old',
                               '21-30 years old',
                               '31-40 years old',
                               '41-50 years old',
                               '51-60 years old',
                               '61-70 years old',
                               '71-80 years old',
                               '81 and older'
                             ),
                             choiceValues = c("19",
                                              "25",
                                              "35",
                                              "45",
                                              "55",
                                              "65",
                                              "75",
                                              "85"),
                             choices = NULL,
                             selected = "35",
                             individual = FALSE,
                             justified = TRUE,
                             status = 'primary',
                             checkIcon = list(yes = icon("ok",
                                                         lib = "glyphicon"))
                           ),
                           
                           fade_in_right(
                             div
                             (
                               radioGroupButtons(
                                 inputId = 'GenderRadio',
                                 label = '',
                                 direction = 'vertical',
                                 width = '100%',
                                 size = 'lg',
                                 choiceNames  = c('Male.',
                                                  'Female.'),
                                 choiceValues = c("2",
                                                  "3"),
                                 choices = NULL,
                                 selected = "2",
                                 individual = FALSE,
                                 justified = TRUE,
                                 status = 'primary',
                                 checkIcon = list(yes = icon("ok",
                                                             lib = "glyphicon"))
                               )
                               
                             )
                             ,
                             duration = 'faster',
                             delay = 2,
                             steps = 50,
                             iteration = NULL
                           )
                           
                           
                         ))
                         ,
                         duration = 'faster',
                         delay = 1,
                         steps = 50,
                         iteration = NULL
                       )
                       
                       ,
                       fade_in_right(
                         div(
                           radioGroupButtons(
                             inputId = 'Submited',
                             label = '',
                             direction = 'vertical',
                             width = '100%',
                             size = 'lg',
                             choiceNames  = c('Start!'),
                             choiceValues = c("Submited"),
                             choices = NULL,
                             selected = "ChestPainSeverity",
                             individual = FALSE,
                             justified = TRUE,
                             status = 'primary',
                             checkIcon = list(yes = icon("ok",
                                                         lib = "glyphicon"))
                             
                           )
                           
                         )   ,
                         duration = 'faster',
                         delay = 3,
                         steps = 50,
                         iteration = NULL
                       )
                     )
                   })
                   
                   
                   
                   
                   
                   
                 }
                 
                 
               })
  observeEvent(input$Submited,
               {
                 shinyjs::disable(id = "answersgenderage")
                 shinyjs::hide(
                   id = "answersgenderage",
                   anim = TRUE,
                   animType = "fade",
                   time = 1
                 )
                 
                 print(paste("submitting age:", input$AgeRadio))
                 repeat {
                   res =  POST(
                     'https://api.endlessmedical.com/v1/dx/UpdateFeature',
                     query = list(
                       SessionID = SessionIDCurrent,
                       name = "Age",
                       value = input$AgeRadio
                     )
                   )
                   if (res$status_code == 200)
                     break
                   {
                     print(res$status_code)
                     print(res)
                     Sys.sleep(5)
                   }
                 }
                 
                 
                 
                 
                 print(paste("submitting gender:", input$GenderRadio))
                 
                 repeat {
                   res =  POST(
                     'https://api.endlessmedical.com/v1/dx/UpdateFeature',
                     query = list(
                       SessionID = SessionIDCurrent,
                       name = "Gender",
                       value = input$GenderRadio
                     )
                   )
                   if (res$status_code == 200)
                     break
                   print(res$status_code)
                   print(res)
                   Sys.sleep(5)
                 }
                 
                 
                 if (input$GenderRadio == 2)
                 {
                   answersShownButNotPicked <<-
                     c(answersShownButNotPicked,
                       "This question doesn't apply to me, as I am female.")
                   answersProvided <<-
                     c(answersProvided,
                       "This question doesn't apply to me, as I am male.")
                   
                 }
                 if (input$GenderRadio == 3)
                 {
                   answersShownButNotPicked <<-
                     c(answersShownButNotPicked,
                       "This question doesn't apply to me, as I am male.")
                   answersProvided <<-
                     c(answersProvided,
                       "This question doesn't apply to me, as I am female.")
                   
                 }
                 Submitted <<- TRUE
                 shinyjs::disable(id = "AgeRadio")
                 shinyjs::disable(id = "GenderRadio")
                 shinyjs::hide("AgeRadio",
                               anim = TRUE,
                               animType = "fade",
                               time = 1)
                 shinyjs::hide(
                   "GenderRadio",
                   anim = TRUE,
                   animType = "fade",
                   time = 1
                 )
                 #   startAnim(session, "GenderRadio","fadeOutUp")
                 #  startAnim(session, "AgeRadio","fadeOutUp")
                 output$question <-
                   
                   
                   renderUI({
                     fade_in_left(
                       (div(
                         class = "yours messages",
                         div(
                           class = "message last",
                           HTML(
                             "Pick now the main symptom or the most bothering problem. Don't worry I will ask more questions about other symptoms once we start."
                           )
                           ,
                           HTML(
                             "<img src='logobluetrans.png'  width='20px' style='margin-left: 0px; margin-right: 0px; margin-top: 0px;  margin-right: 0px; margin-top: 0px;  align:left; float:left; position: relative;
                            top: 22px;
                             left: -38px;
                              '>"
                           )
                           
                         )
                       ))
                       ,
                       duration = 'faster',
                       delay = 0,
                       steps = 50,
                       iteration = NULL
                     )
                     
                     
                   })
                 
                 
                 shinyjs::disable(id = "Submited")
                 shinyjs::hide("Submited",
                               anim = TRUE,
                               animType = "fade",
                               time = 1)
                 
                 
                 #  addClass("Submited", class = "vov hidden fade_out_up")
                 #       startAnim(session, "Submited","fadeOutUp")
                 
                 # startAnim(id = "Submited",)
                 output$answers <- renderUI({
                   fade_in_right((div (
                     radioGroupButtons(
                       inputId = 'answersRadio',
                       label = '',
                       direction = 'vertical',
                       width = '100%',
                       size = 'lg',
                       choiceNames  = c(
                         'Elevated blood pressure.',
                         'Visible blood (red) in urine.',
                         'Red blood cells detected (test) in urine.',
                         'Foamy or bublly urine.',
                         'Protein in urine.',
                         'Burning with urination.',
                         'Straining on urination.',
                         'Feeling of not empyting bladder.',
                         'Swollen legs.',
                         'Pain in legs.',
                         'Headache.',
                         'Cough.',
                         'Fever or high temperature.',
                         'Sore throat.',
                         "Ear pain.",
                         
                         'Shortness of breath.',
                         'Chest pain.',
                         'Fatigue.',                       
                         'Belly or abdominal pain.',
                         'Feeling like vomiting or vomiting.',
                         'Red stools.',
                         'Black stools.',
                         'Diarrhea, loose stools.',
                         'Constipation.',
                         
                         'Abnormal vaginal discharge',
                         'Penile discharge.'
                         
                       ),
                       choiceValues = c(
                         "ElevatedSystolicBp",
                         "GrossHematuria",
                         "MicroscopicHematuriaRBCs",
                         "FoamyUrine",
                         "UAProteinuria",
                         "BurningWithUrination",
                         "StrainStream",
                         "NonEmptyBladder",
                         "Edema",
                         "RestingPainInLowerExtremities",
                         
                         "HeadacheIntensity",
                         "SeverityCough",
                         "HistoryFever",
                         "SoreThroatROS",
                         "EarPainRos",
                         "DyspneaSeveritySubjective",
                         "ChestPainSeverity",
                         "GeneralizedFatigue",
                         "StomachPainSeveritySx",
                         "Nausea",
                         "LowerGIBleedSx",
                         "LowerGIBleedSx",
                         "DiarrheaSx",
                         "Constipation",
                         
                         "FemaleDCSx",
                         "MaleDCSx"
                       ),
                       choices = NULL,
                       selected = '',
                       
                       justified = TRUE,
                       individual = FALSE,
                       status = 'primary',
                       checkIcon = list(yes = icon("ok",
                                                   lib = "glyphicon"))
                     )
                   ))
                   ,
                   duration = 'faster',
                   delay = 1,
                   steps = 50,
                   iteration = NULL
                   )
                   
                 })
               })
  
  observeEvent(input$answersRadio,
               
               {
                 shinyjs::disable(id = "answersRadio")
                 shinyjs::disable(id = "answers")
                 shinyjs::hide(
                   id = "question",
                   anim = TRUE,
                   animType = "fade",
                   time = 1
                 )
                 
                 shinyjs::hide(
                   id = "answersRadio",
                   anim = TRUE,
                   animType = "fade",
                   time = 1
                 )
                 
                 shinyjs::hide(
                   id = "results",
                   anim = TRUE,
                   animType = "fade",
                   time = 1
                   
                 )
                 shinyjs::hide(
                   id = "chronicresults",
                   anim = TRUE,
                   animType = "fade",
                   time = 1
                   
                 )
                 shinyjs::hide(
                   id = "link",
                   anim = TRUE,
                   animType = "fade",
                   time = 1
                   
                 )
                 shinyjs::hide(
                   id = "specs",
                   anim = TRUE,
                   animType = "fade",
                   time = 1
                   
                 )
                 shinyjs::hide(
                   id = "stata",
                   anim = TRUE,
                   animType = "fade",
                   time = 1
                 )
                 Sys.sleep(1.1)
                 if (!selectedMainSymptom)
                 {
                   selectedMainSymptom <<- TRUE
                   
                   
                   shinyjs::show(
                     "BusyIndicator",
                     anim = TRUE,
                     animType = "fade",
                     time = 1
                   )
                   shinyjs::hide(
                     "answersRadio",
                     anim = TRUE,
                     animType = "fade",
                     time = 1
                   )
                   shinyjs::hide("question",
                                 anim = TRUE,
                                 animType = "fade",
                                 time = 1)
                   
                   
                   
                   
                   shinyjs::hide(
                     id = "answersRadio",
                     anim = TRUE,
                     animType = "fade",
                     time = 1
                   )
                   
                   
                   
                   IntentionQue <<- input$answersRadio
                   if (input$answersRadio == "ElevatedSystolicBp")
                   {
                     IntentionQue <<-
                       c(
                         "ElevatedSystolicBp",
                         "ElevatedDiastolicBp",
                         "PMHXHTN",
                         "HeadacheAssociatedWithHTN"
                       )
                   }
                   if (input$answersRadio == "GrossHematuria")
                   {
                     IntentionQue <<-
                       c(
                         "GrossHematuria",
                         "HemoptysisTiming",
                         "BurningWithUrination",
                         "DyspneaSeveritySubjective"
                       )
                   }
                   if (input$answersRadio == "MicroscopicHematuriaRBCs")
                   {
                     IntentionQue <<-
                       c(
                         "MicroscopicHematuriaRBCs",
                         "GrossHematuria",
                         "FoamyUrine",
                         "UAProteinuria",
                         "ElevatedSystolicBp",
                         "ElevatedDiastolicBp",
                         "Edema"
                       )
                   }
                   if (input$answersRadio == "FoamyUrine")
                   {
                     IntentionQue <<-
                       c(
                         "FoamyUrine",
                         "Edema",
                         "UAProteinuria",
                         "ElevatedSystolicBp",
                         "ElevatedDiastolicBp",
                         "PMHXHTN",
                         "PMHXDM1",
                         "PMHXDM2"
                       )
                   }
                   if (input$answersRadio == "UAProteinuria")
                   {
                     IntentionQue <<-
                       c(
                         "UAProteinuria",
                         "Edema",
                         "FoamyUrine",
                         "ElevatedSystolicBp",
                         "ElevatedDiastolicBp",
                         "PMHXHTN",
                         "PMHXDM1",
                         "PMHXDM2"
                       )
                   }
                   if (input$answersRadio == "BurningWithUrination")
                   {
                     IntentionQue <<-
                       c(
                         "BurningWithUrination",
                         "UrinaryFrequency",
                         "HistoryFever",
                         "Chills",
                         "Nausea"
                       )
                   }
                   
                   if (input$answersRadio == "Edema")
                   {
                     IntentionQue <<-
                       c(
                         "Edema",
                         "FoamyUrine",
                         "DyspneaSeveritySubjective",
                         "ParoxysmalNDHx",
                         "DVTSx",
                         "HemoptysisTiming",
                         "FHDVTPEParent",
                         "ElevatedSystolicBp",
                         "PMHXHTN",
                         "PMHXDM1",
                         "PMHXDM2"
                       )
                   }
                   if (input$answersRadio == "RestingPainInLowerExtremities")
                   {
                     IntentionQue <<-
                       c(
                         "RestingPainInLowerExtremities",
                         "Edema",
                         "PMHXGout",
                         "GoutFoods",
                         "GoutyRosPain"
                       )
                   }
                   
                   if (input$answersRadio == "HeadacheIntensity")
                   {
                     IntentionQue <<-
                       c(
                         "HeadacheIntensity",
                         "ElevatedSystolicBp",
                         "ElevatedDiastolicBp",
                         "PMHXHTN"
                       )
                   }
                   if (input$answersRadio == "HistoryFever")
                   {
                     IntentionQue <<-
                       c("HistoryFever",
                         "BurningWithUrination",
                         "SoreThroatROS",
                         "SeverityCough")
                   }
                   
                   if (input$answersRadio == "SoreThroatROS")
                   {
                     IntentionQue <<-
                       c("SoreThroatROS",
                         "HistoryFever",
                         "SeverityCough",
                         "PMHXDM1",
                         "PMHXDM2"
                         
                       )
                   }
                   if (input$answersRadio == "MaleDCx")
                   {
                     IntentionQue <<-
                       c("MaleDCSx",
                         "HistoryFever",
                         "BurningWithUrination",
                         "SexExposure"
                         
                       )
                   }                   
                   
                   
                   Feature <<- IntentionQue[1]
                   print(paste("Zerowanie IntentionQue ***"))
                   #  IntentionQue<<-IntentionQue[-1]
                   
                   #if lrngth(QuestionsToAskQue) >2 QuestionsToAskQue<-QuestionsToAskQue[2:length(QuestionsToAskQue)]
                   print("-------------------------   selected the  symptom per button ")
                 }
                 else
                 {
                   print("-------------------------  selected the  symptom per Analyze ")
                   SoFarFeatures <<- SoFarFeatures + 1
                   print(" Updating feature...")
                   print(paste(" So far features:",SoFarFeatures))
                   
                   Order <- which (FeaturesNames == Feature)
                   choiceWhich <-
                     which (unlist(ChoicesValues[Order]) == input$answersRadio)
                   choiceName <-
                     unlist(ChoicesLayTexts[Order])[choiceWhich]
                   choicesNotPickednames <-
                     unlist(ChoicesLayTexts[Order])[-choiceWhich]
                   choicesNotPickednames <-
                     choicesNotPickednames[-1] # remove Data unavailable. as this is not trully picked by users.
                   choicesNotPickednames <-
                     choicesNotPickednames[nchar(choicesNotPickednames) > 8]
                   print(Order)
                   print(choiceWhich)
                   print(choiceName)
                   
                   
                   if (length(choiceName) > 0)
                     if (nchar(choiceName) > 8)
                       answersProvided <<-
                     c(answersProvided, choiceName)
                   #  print(paste("---------->So far user provided following asnwers: ", unique(answersProvided)))
                   
                   if (length(choicesNotPickednames) > 0)
                     answersShownButNotPicked <<-
                     unique(c(answersShownButNotPicked, choicesNotPickednames))
                   #  print(paste("---------->So far user did not pick  following asnwers: ",answersShownButNotPicked))
                   
                   
                   print(paste(
                     "submitting value:",
                     input$answersRadio,
                     " to feature: ",
                     Feature
                   ))
                   repeat {
                     res =  POST(
                       'https://api.endlessmedical.com/v1/dx/UpdateFeature',
                       query = list(
                         SessionID = SessionIDCurrent,
                         name = Feature,
                         value = input$answersRadio
                       )
                     )
                     if (res$status_code == 200)
                       break
                     print(res$status_code)
                     print(res)
                     Sys.sleep(2)
                   }
                   
                   
                   print(paste("!!!!updated:", Feature))
                   print("analyzing...")
                   repeat {
                     res = GET(
                       'https://api.endlessmedical.com/v1/dx/Analyze',
                       query = list(SessionID = SessionIDCurrent,
                                    NumberOfResults = 140)
                     )
                     if (res$status_code == 200)
                       break
                     print(res$status_code)
                     print(res)
                     Sys.sleep(2)
                   }
                   
                   resR <- (fromJSON(rawToChar(res$content)))[[2]]
                   
                   Diseases <-
                     unlist(lapply(resR, function(pred) {
                       unlist(pred[1])
                     }))
                   print(Diseases[1:15])
                   
                   STATAID <<-
                     which('Patient in immediate life-threatening condition' == names(Diseases))[1]
                   if (!is.na(STATAID))
                   {
                     STATAPercent <<- (as.numeric(as.character(Diseases[STATAID])))
                     STATAPercent <<- (STATAPercent) * 100
                     #    STATAPercent[STATAPercent<0]<<- 0
                     #STATAPercent<<-STATAPercent*2
                     
                     if (STATAPercent > 90) {
                       STATAStatus <- "danger"
                     } else {
                       STATAStatus <- "warning"
                     }
                     Diseases <- Diseases[-STATAID]
                     print("STATA")
                     print(STATAPercent)
                   }
                   else
                     print("NO STATA")
                   
                   
                   DiseasesNames <- names(Diseases)
                   
                   DiseasesPercents <-
                     (as.numeric(as.character(Diseases))) * 100
                   # DiseasesPercents[DiseasesPercents<0] <- 0
                   DiseasesPercents <- DiseasesPercents
                   
                   
                   ResultsNames <<-
                     DiseasesNames[which(DiseasesPercents > 10)]
                   ResultsPercents <<-
                     DiseasesPercents[which(DiseasesPercents > 10)]
                   print(paste(ResultsPercents[1:15], collapse = ", "))
                   print(paste(ResultsNames[1:15], collapse = ", "))
                   ResultsStatus <<-
                     rep("warning", length(ResultsNames))
                   ResultsStatus[which(ResultsPercents > 90)] <<-
                     "danger"
                   print(paste(
                     "Getting specializations for session ID: ",
                     SessionIDCurrent
                   ))
                   repeat {
                     res =  GET(
                       'https://api.endlessmedical.com/v1/dx/GetSuggestedSpecializations',
                       query = list(SessionID = SessionIDCurrent, NumberOfResults =
                                      10)
                     )
                     if (res$status_code == 200)
                       break
                     print(res$status_code)
                     print(res)
                     Sys.sleep(5)
                   }
                   repeat {
                     resR <- (fromJSON(rawToChar(res$content)))[[2]]
                     Specki <<-
                       unlist(lapply(resR, function(pred) {
                         unlist(pred[1])
                       }))
                     if (res$status_code == 200)
                       break
                     print(res$status_code)
                     print(res)
                   }
                   print(paste0(
                     "Recommended specializations: ",
                     paste(Specki, collapse = ', ')
                   ))
                   
                   
                   print(paste(
                     "Getting next suggetsted for session ID: ",
                     SessionIDCurrent
                   ))
                   repeat {
                     res =  GET(
                       'https://api.endlessmedical.com/v1/dx/GetSuggestedFeatures_PhysicianProvided',
                       query = list(SessionID = SessionIDCurrent, TopDiseasesToTake =
                                      100)
                     )
                     if (res$status_code == 200)
                       break
                     print(res$status_code)
                     print(res)
                     
                     Sys.sleep(2)
                   }
                   
                   resR <- (fromJSON(rawToChar(res$content)))[[2]]
                   SuggestedV <-
                     unlist(lapply(resR, function(pred) {
                       unlist(pred[1])
                     }))
                   
                   
                   FeaturesNamesV <- unlist(FeaturesNames)
                   names(FeaturesNamesV) <- FeaturesNamesV
                   FeaturesNamesV <- c(1:length(FeaturesNamesV))
                   names(FeaturesNamesV) <- unlist(FeaturesNames)
                   
                   
                   repeat {
                     res =  GET(
                       'https://api.endlessmedical.com/v1/dx/GetSuggestedFeatures_PatientProvided',
                       query = list(SessionID = SessionIDCurrent, TopDiseasesToTake =
                                      100)
                     )
                     if (res$status_code == 200)
                       break
                     print(res$status_code)
                     print(res)
                     Sys.sleep(5)
                   }
                   
                   resR <- (fromJSON(rawToChar(res$content)))[[2]]
                   
                   SuggestedByPatient <-
                     unlist(lapply(resR, function(pred) {
                       (pred[1])
                     }))
                   
                   Feature <<- SuggestedByPatient[1]
                   SuggestedVIndexesByPatient <-
                     FeaturesNamesV[Feature]
                   SuggestedVIndexes <- FeaturesNamesV[SuggestedV]
                   SuggestedcategoriesV <-
                     (FeatureCategories)[SuggestedVIndexes]
                   IndexOfFirstPastMedicalHistory <-
                     which(SuggestedcategoriesV == "Past medical history")[1]
                   IndexOfFirstSocialHistory <-
                     which(SuggestedcategoriesV == "Social history")[1]
                   IndexOfFirstFamilyHistory <-
                     which(SuggestedcategoriesV == "Family history")[1]
                   IndexOfFirstReviewOfSystem <-
                     (grep("review of system", (SuggestedcategoriesV)))[1]
                   
                   
                   #       if (IndexOfFirstPastMedicalHistory<IndexOfFirstReviewOfSystem) {Feature<<-SuggestedV[IndexOfFirstPastMedicalHistory]}
                   
                   
                   MinimalIndex <-
                     min(na.omit(
                       c(
                         IndexOfFirstPastMedicalHistory,
                         IndexOfFirstSocialHistory,
                         IndexOfFirstFamilyHistory,
                         IndexOfFirstReviewOfSystem
                       )
                     ))
                   
                   Feature <<- SuggestedV[MinimalIndex]
                   
                   Suggested <<- SuggestedByPatient
                   if (MinimalIndex == Inf)
                     Feature <<- NULL
                   
                   print(paste("*** IntentionQue :", IntentionQue))
                   print(is.na(IntentionQue))
                   print(is.null(IntentionQue))
                   print(paste("*** Feature :", Feature))
                   
                   
                   if (length(IntentionQue) > 0)
                   {
                     Feature <<- IntentionQue[1]
                     IntentionQue <<- IntentionQue[-1]
                   }
                   
                   print(paste("*** IntentionQue :", IntentionQue))
                   print(is.na(IntentionQue))
                   print(is.null(IntentionQue))
                   print(paste("*** Feature :", Feature))
                   
                   
                   
                   print(paste(
                     "Getting specializations for session ID: ",
                     SessionIDCurrent
                   ))
                   repeat {
                     res =  GET(
                       'https://api.endlessmedical.com/v1/dx/GetSuggestedSpecializations',
                       query = list(SessionID = SessionIDCurrent, NumberOfResults =
                                      10)
                     )
                     if (res$status_code == 200)
                       break
                     print(res$status_code)
                     print(res)
                     Sys.sleep(5)
                   }
                   
                   print(paste0(
                     "Recommended specializations: ",
                     paste(Specki, collapse = ', ')
                   ))
                   
                   
                   # print(paste(ResultsNames[1:15], collapse = ", "))
                   print(paste(ResultsPercents[1:15], collapse = ", "))
                   
                   
                   
                   
                   SpecialtyNames <- Specki
                   SpecialtyPercents <-
                     c(1, 1, 1)
                   
                   
                   
                   
                   
                   
                   print(paste(
                     "Recommended specializations: ",
                     paste(Specki, collapse = ', ')
                   ))
                   
                   
                   
                   
                   print(paste("Next suggested: ", MinimalIndex, Feature))
                   repeat {
                     Order <- which (FeaturesNames == Feature)
                     allAnswersForFeature <-
                       unlist(ChoicesLayTexts[Order])
                     if (!(any(answersProvided %in% allAnswersForFeature))) {
                       break
                     }
                     
                     
                     ValueAnsweredBefore <-
                       unlist(ChoicesValues[Order])[which(allAnswersForFeature %in% answersProvided)[1]]
                     
                     repeat {
                       res =  POST(
                         'https://api.endlessmedical.com/v1/dx/UpdateFeature',
                         query = list(
                           SessionID = SessionIDCurrent,
                           name = Feature,
                           value = ValueAnsweredBefore
                         )
                       )
                       if (res$status_code == 200)
                         break
                       print(res$status_code)
                       print(res)
                       Sys.sleep(5)
                     }
                     
                     
                     print(paste("Updated:", Feature))
                     #    print(fromJSON(rawToChar(res$content)))
                     
                     print(
                       paste(
                         "#################### Auto submitting answer: to feature: ",
                         Feature,
                         ", value: ",
                         ValueAnsweredBefore,
                         ", as before it has been said: ",
                         allAnswersForFeature[which(allAnswersForFeature %in% answersProvided)[1]]
                       )
                     )
                     
                     print("analyzing...")
                     repeat {
                       res = GET(
                         'https://api.endlessmedical.com/v1/dx/Analyze',
                         query = list(SessionID = SessionIDCurrent, NumberOfResults =
                                        140)
                       )
                       if (res$status_code == 200)
                         break
                       print(res$status_code)
                       print(res)
                       Sys.sleep(5)
                     }
                     resR <- (fromJSON(rawToChar(res$content)))[[2]]
                     
                     Diseases <-
                       unlist(lapply(resR, function(pred) {
                         unlist(pred[1])
                       }))
                     STATAID <<-
                       which('Patient in immediate life-threatening condition' == names(Diseases))[1]
                     if (!is.na(STATAID))
                     {
                       STATAPercent <<- (as.numeric(as.character(Diseases[STATAID]))) * 100
                       # STATAPercent[STATAPercent<0] <<-0
                       STATAPercent <<- STATAPercent
                       
                       if (STATAPercent > 90) {
                         STATAStatus <- "danger"
                       } else {
                         STATAStatus <- "warning"
                       }
                       Diseases <- Diseases[-STATAID]
                       print("STATA")
                       print(STATAPercent)
                     }
                     else
                       print("NO STATA")
                     
                     #    print(Diseases)
                     DiseasesNames <- names(Diseases)
                     DiseasesPercents <-
                       (as.numeric(as.character(Diseases))) * 100
                     #  DiseasesPercents[DiseasesPercents<0] <- 0
                     DiseasesPercents <- DiseasesPercents
                     #    print(DiseasesNames)
                     ResultsNames <<-
                       DiseasesNames[which(DiseasesPercents > 10)]
                     ResultsPercents <<-
                       DiseasesPercents[which(DiseasesPercents > 10)]
                     print(paste(ResultsPercents[1:15], collapse = ", "))
                     print(paste(ResultsNames[1:15], collapse = ", "))
                     ResultsStatus <<-
                       rep("warning", length(ResultsNames))
                     ResultsStatus[which(ResultsPercents > 90)] <<-
                       "danger"
                     print("getting next suggested...")
                     repeat {
                       res =  GET(
                         'https://api.endlessmedical.com/v1/dx/GetSuggestedFeatures_PhysicianProvided',
                         query = list(
                           SessionID = SessionIDCurrent,
                           TopDiseasesToTake = 100
                         )
                       )
                       if (res$status_code == 200)
                         break
                       print(res$status_code)
                       print(res)
                       Sys.sleep(5)
                     }
                     
                     resR <-
                       (fromJSON(rawToChar(res$content)))[[2]]
                     SuggestedV <-
                       unlist(lapply(resR, function(pred) {
                         unlist(pred[1])
                       }))
                     
                     
                     FeaturesNamesV <- unlist(FeaturesNames)
                     names(FeaturesNamesV) <- FeaturesNamesV
                     FeaturesNamesV <- c(1:length(FeaturesNamesV))
                     names(FeaturesNamesV) <- unlist(FeaturesNames)
                     
                     
                     repeat {
                       res =  GET(
                         'https://api.endlessmedical.com/v1/dx/GetSuggestedFeatures_PatientProvided',
                         query = list(
                           SessionID = SessionIDCurrent,
                           TopDiseasesToTake = 100
                         )
                       )
                       if (res$status_code == 200)
                         break
                       print(res$status_code)
                       print(res)
                       Sys.sleep(5)
                     }
                     resR <- (fromJSON(rawToChar(res$content)))[[2]]
                     
                     SuggestedByPatient <-
                       unlist(lapply(resR, function(pred) {
                         (pred[1])
                       }))
                     
                     Feature <<- SuggestedByPatient[1]
                     SuggestedVIndexesByPatient <-
                       FeaturesNamesV[Feature]
                     SuggestedVIndexes <- FeaturesNamesV[SuggestedV]
                     SuggestedcategoriesV <-
                       (FeatureCategories)[SuggestedVIndexes]
                     IndexOfFirstPastMedicalHistory <-
                       which(SuggestedcategoriesV == "Past medical history")[1]
                     IndexOfFirstSocialHistory <-
                       which(SuggestedcategoriesV == "Social history")[1]
                     IndexOfFirstFamilyHistory <-
                       which(SuggestedcategoriesV == "Family history")[1]
                     
                     IndexOfFirstReviewOfSystem <-
                       (grep("review of system", (SuggestedcategoriesV)))[1]
                     
                     #       if (IndexOfFirstPastMedicalHistory<IndexOfFirstReviewOfSystem) {Feature<<-SuggestedV[IndexOfFirstPastMedicalHistory]}
                     
                     
                     MinimalIndex <-
                       min(na.omit(
                         c(
                           IndexOfFirstPastMedicalHistory,
                           IndexOfFirstSocialHistory,
                           IndexOfFirstFamilyHistory,
                           IndexOfFirstReviewOfSystem
                         )
                       ))
                     
                     Feature <<- SuggestedV[MinimalIndex]
                     if (MinimalIndex == Inf)
                       Feature <<- NULL
                     Suggested <<- SuggestedByPatient
                     print(paste("Feature: ", Feature))
                   }
                   ## end auto-submitting answers already providers until next features has no answer already submitted.
                 }
                 Order <- which (FeaturesNames == Feature)
                 choiceNamesV <- unlist(ChoicesLayTexts[Order])
                 choiceValuesV <- unlist(ChoicesValues[Order])
                 
                 
                 
                 if (SoFarFeatures > 0)
                 {
                   choiceNamesV <-
                     c("Skip this question.", choiceNamesV[2:length(choiceNamesV)])
                   choiceValuesV <-
                     c("NA", choiceValuesV[2:length(choiceValuesV)])
                 } else
                 {
                   choiceNamesV <- choiceNamesV[2:length(choiceNamesV)]
                   choiceValuesV <-
                     choiceValuesV[2:length(choiceValuesV)]
                   
                 }
                 
                 ## dont show  answers already given if longer than 9 chars
                 ## as they were  not picked before anyways - so no point of showing them
                 ## remove choices already shown before, but not picked by the user
                 
                 allAnswersForFeature <-
                   unlist(ChoicesLayTexts[Order])
                 allValuesForFeature <- unlist(ChoicesValues[Order])
                 repeat {
                   Order <- which (FeaturesNames == Feature)
                   
                   if (!(any(answersShownButNotPicked %in% choiceNamesV))) {
                     print(paste("Breaking"))
                     break
                   }
                   
                   print(
                     paste(
                       "------------- Auto-removing answer: ",
                       allAnswersForFeature[which(allAnswersForFeature %in% answersShownButNotPicked)[1]],
                       " from the feature: ",
                       Feature,
                       " as it was already shown and was not picked..."
                     )
                   )
                   ValueToRemove <-
                     allValuesForFeature[which(allAnswersForFeature %in% answersShownButNotPicked)[1]]
                   
                   print(paste("NOT BREAKING"))
                   #  print(choiceNamesV)
                   #      print(choiceValuesV)
                   
                   choiceValuesV <-
                     choiceValuesV[!(choiceNamesV %in% allAnswersForFeature[which(allAnswersForFeature %in% answersShownButNotPicked)])]
                   choiceNamesV <-
                     choiceNamesV[!(choiceNamesV %in% allAnswersForFeature[which(allAnswersForFeature %in% answersShownButNotPicked)])]
                   
                   
                   if (length(choiceNamesV) < 3)
                   {
                     print(paste (
                       "Have only 1 answer left:",
                       paste(ChoiceNames, collapse = ", ")
                     ))
                     
                     
                     
                     repeat {
                       res =  POST(
                         'https://api.endlessmedical.com/v1/dx/UpdateFeature',
                         query = list(
                           SessionID = SessionIDCurrent,
                           name = Feature,
                           value = (choiceValuesV[2])
                         )
                       )
                       if (res$status_code == 200)
                         break
                       
                       print(res$status_code)
                       print(res)
                       Sys.sleep(5)
                     }
                     print(paste("Updated: ", Feature))
                     #    print(fromJSON(rawToChar(res$content)))
                     
                     print(
                       paste(
                         "------------- Auto submitting NA : to feature: ",
                         Feature,
                         " as there is no valid options to be shown left."
                       )
                     )
                     
                     
                     print("analyzing...")
                     repeat {
                       res = GET(
                         'https://api.endlessmedical.com/v1/dx/Analyze',
                         query = list(SessionID = SessionIDCurrent,
                                      NumberOfResults = 140)
                       )
                       if (res$status_code == 200)
                         break
                       print(res$status_code)
                       print(res)
                       Sys.sleep(5)
                     }
                     
                     resR <- (fromJSON(rawToChar(res$content)))[[2]]
                     
                     Diseases <-
                       unlist(lapply(resR, function(pred) {
                         unlist(pred[1])
                       }))
                     
                     #   importR<-(fromJSON(rawToChar(res$content)))[[3]]
                     #   Importance<-     (lapply(importR[[1]], function(pred) { print(pred) }))
                     
                     
                     
                     
                     #  print(Diseases)
                     
                     
                     STATAID <<-
                       which('Patient in immediate life-threatening condition' == names(Diseases))[1]
                     if (!is.na(STATAID))
                     {
                       STATAPercent <<- (as.numeric(as.character(Diseases[STATAID]))) * 100
                       
                       
                       #   STATAPercent[STATAPercent<0]<<-0
                       STATAPercent <<- STATAPercent
                       
                       
                       if (STATAPercent > 90) {
                         STATAStatus <- "danger"
                       } else {
                         STATAStatus <- "warning"
                       }
                       Diseases <- Diseases[-STATAID]
                       
                       DiseasesNames <- names(Diseases)
                       print("STATA")
                       print(STATAPercent)
                     }
                     else
                       print("NO STATA")
                     DiseasesNames <- names(Diseases)
                     
                     DiseasesPercents <-
                       (as.numeric(as.character(Diseases))) * 100
                     #   DiseasesPercents[DiseasesPercents<0] <- 0
                     DiseasesPercents <- DiseasesPercents
                     ResultsNames <<-
                       DiseasesNames[which(DiseasesPercents > 10)]
                     
                     ResultsPercents <<-
                       DiseasesPercents[which(DiseasesPercents > 10)]
                     print(paste(ResultsPercents[1:15], collapse = ", "))
                     print(paste(ResultsNames[1:15], collapse = ", "))
                     ResultsStatus <<-
                       rep("warning", length(ResultsNames))
                     ResultsStatus[which(ResultsPercents > 90)] <<-
                       "danger"
                     
                     
                     ##################################################
                     ResultsNames <<-
                       Diseases_LayTexts[DiseasesNames[which(DiseasesPercents > 10)]]
                     
                     print(paste(
                       "Getting specializations for session ID: ",
                       SessionIDCurrent
                     ))
                     repeat {
                       res =  GET(
                         'https://api.endlessmedical.com/v1/dx/GetSuggestedSpecializations',
                         query = list(SessionID = SessionIDCurrent,
                                      NumberOfResults = 10)
                       )
                       if (res$status_code == 200)
                         break
                       print(res$status_code)
                       print(res)
                       Sys.sleep(5)
                     }
                     resR <-
                       (fromJSON(rawToChar(res$content)))[[2]]
                     Specki <<-
                       unlist(lapply(resR, function(pred) {
                         unlist(pred[1])
                       }))
                     print(paste0(
                       "Recommended specializations: ",
                       paste(Specki, collapse = ', ')
                     ))
                     
                     
                     print(paste(
                       "Getting next suggetsted for session ID: ",
                       SessionIDCurrent
                     ))
                     
                     
                     repeat {
                       res =  GET(
                         'https://api.endlessmedical.com/v1/dx/GetSuggestedFeatures_PhysicianProvided',
                         query = list(
                           SessionID = SessionIDCurrent,
                           TopDiseasesToTake = 100
                         )
                       )
                       if (res$status_code == 200)
                         break
                       print(res$status_code)
                       print(res)
                       Sys.sleep(5)
                     }
                     
                     resR <-
                       (fromJSON(rawToChar(res$content)))[[2]]
                     SuggestedV <-
                       unlist(lapply(resR, function(pred) {
                         unlist(pred[1])
                       }))
                     FeaturesNamesV <<- unlist(FeaturesNames)
                     names(FeaturesNamesV) <<- FeaturesNamesV
                     FeaturesNamesV <<- c(1:length(FeaturesNamesV))
                     names(FeaturesNamesV) <<- unlist(FeaturesNames)
                     repeat {
                       res =  GET(
                         'https://api.endlessmedical.com/v1/dx/GetSuggestedFeatures_PatientProvided',
                         query = list(
                           SessionID = SessionIDCurrent,
                           TopDiseasesToTake = 100
                         )
                       )
                       if (res$status_code == 200)
                         break
                       print(res$status_code)
                       print(res)
                       Sys.sleep(5)
                     }
                     
                     resR <- (fromJSON(rawToChar(res$content)))[[2]]
                     
                     SuggestedByPatient <<-
                       unlist(lapply(resR, function(pred) {
                         (pred[1])
                       }))
                     
                     Feature <<- SuggestedByPatient[1]
                     SuggestedVIndexesByPatient <-
                       FeaturesNamesV[Feature]
                     SuggestedVIndexes <- FeaturesNamesV[SuggestedV]
                     SuggestedcategoriesV <-
                       (FeatureCategories)[SuggestedVIndexes]
                     
                     IndexOfFirstPastMedicalHistory <-
                       which(SuggestedcategoriesV == "Past medical history")[1]
                     IndexOfFirstSocialHistory <-
                       which(SuggestedcategoriesV == "Social history")[1]
                     IndexOfFirstFamilyHistory <-
                       which(SuggestedcategoriesV == "Family history")[1]
                     
                     IndexOfFirstReviewOfSystem <-
                       (grep("review of system", (SuggestedcategoriesV)))[1]
                     
                     
                     MinimalIndex <-
                       min(na.omit(
                         c(
                           IndexOfFirstPastMedicalHistory,
                           IndexOfFirstSocialHistory,
                           IndexOfFirstFamilyHistory,
                           IndexOfFirstReviewOfSystem
                         )
                       ))
                     Feature <<- SuggestedV[MinimalIndex]
                     if (MinimalIndex == Inf)
                       Feature <<- NULL
                     Suggested <<- SuggestedByPatient
                     print("Feature")
                     Order <- which (FeaturesNames == Feature)
                     allAnswersForFeature <-
                       unlist(ChoicesLayTexts[Order])
                     choiceNamesV <- unlist(ChoicesLayTexts[Order])
                     choiceValuesV <- unlist(ChoicesValues[Order])
                     if (SoFarFeatures > 0)
                     {
                       choiceNamesV <-
                         c("Skip this question.", choiceNamesV[2:length(choiceNamesV)])
                       choiceValuesV <-
                         c("NA", choiceValuesV[2:length(choiceValuesV)])
                     } else
                     {
                       choiceNamesV <- choiceNamesV[2:length(choiceNamesV)]
                       choiceValuesV <-
                         choiceValuesV[2:length(choiceValuesV)]
                     }
                   }
                   
                 }
                 
                 ## end removing answers already shown but not picked  (until we have at least 1 answer besides Skip)
                 
                 
                 LabelV <- unlist(LayQuestions[Order])
                 ## zadaj nowe pytanie i wyswietl je oraz odpowiedzi
                 
                 if ((SoFarFeatures < 65) && (!is.null(Feature)))
                 {
                   print(Feature)
                   print("NULL")
                   
                   
                   output$question <-
                     renderUI({
                       shinyjs::show(id = "question")
                       
                       fade_in_left(
                         (div(
                           class = "yours messages",
                           div(
                             class = "message last",
                             HTML(paste0(LabelV)),
                             HTML(
                               "<img src='logobluetrans.png'  width='20px' style='margin-left: 0px; margin-right: 0px; margin-top: 0px;  margin-right: 0px; margin-top: 0px;  align:left; float:left; position: relative;
                            top: +24px;
                            left: -44px;
                            '>"
                               
                               
                               
                             )
                             
                           )
                         ))
                         ,
                         duration = 'faster',
                         delay = 0,
                         steps = 50,
                         iteration = NULL
                       )
                       
                       
                       
                       
                     })
                   shinyjs::show(id = "question")#,anim = TRUE, animType = "fade", time = 1)
                   
                   
                   
                   output$answers <- renderUI({
                     fade_in_right(
                       div (
                         radioGroupButtons(
                           inputId = 'answersRadio',
                           label = '',
                           direction = 'vertical',
                           width = '100%',
                           size = 'lg',
                           choiceNames  = choiceNamesV,
                           choiceValues = choiceValuesV,
                           choices = NULL,
                           selected = 0,
                           individual = FALSE,
                           justified = TRUE,
                           status = 'primary',
                           checkIcon = list(yes = icon("ok",
                                                       lib = "glyphicon"))
                           
                         ),
                       )
                       
                       ,
                       duration = 'faster',
                       delay = 1,
                       steps = 50,
                       iteration = NULL
                     )
                     
                   })
                   shinyjs::show(id = "question")
                 }
                 else
                 {
                   shinyjs::hide(
                     id = "answers",
                     anim = TRUE,
                     animType = "fade",
                     time = 1
                   )
                   #      addClass("answers", class = "vov hidden fade_out_up")
                   #startAnim(id = "answers","fade_out_up")
                   #   startAnim(session, "asnwers","fadeOutUp")
                   output$question <-
                     renderUI({
                       fade_in_left(
                         (div(
                           class = "yours messages",
                           div(
                             class = "message last",
                             HTML(
                               "Thank you! I think I have found enough about your symptoms. I hope you will soon get better. Remember to always immediately seek medical professional advice, I am not a healthcare provider. </br> If you want to start from scratch, please refresh the website. Have a great day!"
                             )
                             ,
                             HTML(
                               "<img src='logobluetrans.png'  width='20px' style='margin-left: 0px; margin-right: 0px; margin-top: 0px;  align:left; float:left; position: relative;
                                top: 48px;
                                left: -48px;
                                      '>"
                             )
                           )
                         ))
                         ,
                         duration = 'faster',
                         delay = 1,
                         steps = 50,
                         iteration = NULL
                       )
                       
                       
                       
                     })
                   
                 }
                 if (SoFarFeatures > 15)
                   res =  POST(
                     'https://api.endlessmedical.com/v1/dx/SetUseDefaultValues',
                     query = list(SessionID = SessionIDCurrent,
                                  value = TRUE)
                   )
                 
                 if (SoFarFeatures > HowManyQuestionsToAskBeforeShowingResults())
                   if (length(ResultsStatus) > 0)
                     if ((ResultsPercents[1] > 20))
                       
                     {
                       
                       
                       
                       
                       
                       
                       # from now on ResultsNames carries only Acute diseases (per 'category' field of DiseasesOutput.json)
                       # from now on ChronicProblems carries only Chronic diseases (per 'category' field of DiseasesOutput.json)
                       ChronicResultsIndexes<-Diseases_LayTexts[ResultsNames] %in% Chronic_Diseases_LayTextx
                       ChronicResultsNames<-ResultsNames[ChronicResultsIndexes]
                       ChronicResultsStatus<-ResultsStatus[ChronicResultsIndexes]     
                       ChronicResultsPercents<-ResultsPercents[ChronicResultsIndexes] 
                       
                       AcuteResultsIndexes<-Diseases_LayTexts[ResultsNames] %in% Acute_Diseases_LayTextx
                       AcuteResultsNames<-ResultsNames[AcuteResultsIndexes]
                       AcuteResultsStatus<-ResultsStatus[AcuteResultsIndexes]     
                       AcuteResultsPercents<-ResultsPercents[AcuteResultsIndexes]                       
                       
                       
                       ResultsNames<-AcuteResultsNames
                       ResultsStatus<-AcuteResultsStatus 
                       ResultsPercents<-AcuteResultsPercents                         
                       
                       shinyjs::show(id = "results")#,anim = TRUE, animType = "fade", time = 1)
                       shinyjs::show(id = "chronicresults")#,anim = TRUE, animType = "fade", time = 1)
                       shinyjs::show(id = "specs")#,anim = TRUE, animType = "fade", time = 1)
                       shinyjs::show(id = "stata")#,anim = TRUE, animType = "fade", time = 1)
                       shinyjs::show(id = "link")#,anim = TRUE, animType = "fade", time = 1)
                       if (!is.na (STATAID))
                       {
                         shinyjs::show(id = "stata")#,anim = TRUE, animType = "fade", time = 1)
                         output$stata <- renderUI({
                           fade_in_left(
                             (div(
                               class = "yours messages",
                               div(
                                 class = "message",
                                 HTML(
                                   "Bar below shows chances of provided symptoms being life-threatening."
                                 ),
                                 br(),
                                 br(),
                                 
                                 HTML(
                                   paste(
                                     "
               <table style='align:center; width:90%;

                          text-indent: -3px;
                          line-height: 1.35;
                          color: black;
                          position: relative;
                          background: #EEE;
                          border-color: #ffffff;
                          shadow-box: 1px 1px 1px 1px;
                          text-align: left;
                          font-size:15px;
                          border-style:note;



                          '>
                          <tr>
                          <td>"
                                   )
                                 ),
                                 
                                 
                                 progressBar(
                                   id = "pb1",
                                   status = STATAStatus,
                                   value = round(STATAPercent)
                                 ),
                                 HTML("

                                 </td>
                                </tr> </table>")
                                 
                                 
                                 
                                 
                               )
                             ))
                             ,
                             duration = 'faster',
                             delay = 0,
                             steps = 50,
                             iteration = NULL
                           )
                           
                         })
                         
                       }
                       
                       if (length (Specki)>0)
                       {
                         shinyjs::show(id = "specs")#,anim = TRUE, animType = "fade", time = 1)
                         output$specs <- renderUI({
                           fade_in_left(
                             (div(
                               class = "yours messages",
                               div(
                                 class = "message",
                                 
                                 
                                 HTML(
                                   paste0(
                                     "Medical specialties associated with provided symptoms: ",
                                     paste(na.omit(Specki[1:3]), collapse = ", ")
                                   )
                                 ),
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                                 
                               )
                             ))
                             ,
                             duration = 'faster',
                             delay = 0,
                             steps = 50,
                             iteration = NULL
                           )
                           
                         })
                         
                       }                       
                       
                       
                       
                       
                       if (length(ResultsNames)>0)
                       {
                         
                         output$results <- renderUI({
                           fade_in_left((div(
                             class = "yours messages",
                             div(
                               class = "message",
                               
                               
                               
                               HTML(paste0(
                                 "Your answers are usually associated with the following <b><u> acute medical problems: </b></u>",paste0(na.omit(ResultsNames),collapse=', '))
                               ),
                               br(),
                               br(),
                               
                               #               HTML(
                               #                 paste(
                               #                   "
                               # <table style='align:center; width:90%;
                               # 
                               #            text-indent: -3px;
                               #            line-height: 1.35;
                               #            color: black;
                               #            position: relative;
                               #            background: #EEE;
                               #            border-color: #ffffff;
                               #            shadow-box: 1px 1px 1px 1px;
                               #            text-align: left;
                               #            font-size:15px;
                               #            border-style:note;
                               #            '>
                               #            <tr>
                               #            <td>",
                               #                   Diseases_LayTexts[ResultsNames [1]]
                               #                 )
                               #               ),
                               #               
                               #               
                               #               progressBar(
                               #                 id = "pb1",
                               #                 status = ResultsStatus[1],
                               #                 value = round(ResultsPercents[1])
                               #               ),
                               #               HTML("
                               #                    </td>
                               #                     </tr>"),
                               #               
                               #               if (!is.na(ResultsNames[2]))
                               #                 HTML(" <tr>    <td>"),
                               #               if (!is.na(ResultsNames[2]))
                               #                 Diseases_LayTexts[ResultsNames[2]],
                               #               if (!is.na(ResultsNames[2]))
                               #                 progressBar(
                               #                   id = "pb1",
                               #                   status = ResultsStatus[2],
                               #                   value = round(ResultsPercents[2])
                               #                 ),
                               #               if (!is.na(ResultsNames[2]))
                               #                 HTML(" </tr>    </td>"),
                               #               
                               #               
                               #               if (!is.na(ResultsNames[3]))
                               #                 HTML(" <tr>    <td>"),
                               #               if (!is.na(ResultsNames[3]))
                               #                 Diseases_LayTexts[ ResultsNames[3]],
                               #               if (!is.na(ResultsNames[3]))
                               #                 progressBar(
                               #                   id = "pb1",
                               #                   status = ResultsStatus[3],
                               #                   value = round(ResultsPercents[3])
                               #                 ),
                               #               if (!is.na(ResultsNames[3]))
                               #                 HTML(" </tr>    </td>"),
                               #               
                               #               if (!is.na(ResultsNames[4]))
                               #                 HTML(" <tr>    <td>"),
                               #               if (!is.na(ResultsNames[4]))
                               #                 Diseases_LayTexts[ResultsNames[4]],
                               #               if (!is.na(ResultsNames[4]))
                               #                 progressBar(
                               #                   id = "pb1",
                               #                   status = ResultsStatus[4],
                               #                   value = round(ResultsPercents[4])
                               #                 ),
                               #               if (!is.na(ResultsNames[4]))
                               #                 HTML(" </tr>    </td>"),
                               #               
                               #               if (!is.na(ResultsNames[5]))
                               #                 HTML(" <tr>    <td>"),
                               #               if (!is.na(ResultsNames[5]))
                               #                 Diseases_LayTexts[ResultsNames[5]],
                               #               if (!is.na(ResultsNames[5]))
                               #                 progressBar(
                               #                   id = "pb1",
                               #                   status = ResultsStatus[5],
                               #                   value = round(ResultsPercents[5])
                               #                 ),
                               #               if (!is.na(ResultsNames[5]))
                               #                 HTML(" </tr>    </td>"),
                               #               
                               #                
                               #               
                               #               
                               #               HTML("
                               # 
                               #               </table>
                               # 
                               #                   ")
                               
                             )
                           ))
                           ,
                           duration = 'faster',
                           delay = 0,
                           steps = 50,
                           iteration = NULL
                           )
                           
                         })
                       }
                       
                       if (length(ChronicResultsNames)>0)
                       {
                         
                         output$chronicresults <- renderUI({
                           fade_in_left((div(
                             class = "yours messages",
                             div(
                               class = "message",
                               
                               
                               HTML(paste0(
                                 "These are the <b><u>chronic medical problems</b></u> applicable to information yu have provided: ",paste0(na.omit(ChronicResultsNames),collapse=', '))
                               ),
                               
                               br(),
                               br(),
                               
                               #                 HTML(
                               #                   paste(
                               #                     "
                               # <table style='align:center; width:90%;
                               # 
                               #            text-indent: -3px;
                               #            line-height: 1.35;
                               #            color: black;
                               #            position: relative;
                               #            background: #EEE;
                               #            border-color: #ffffff;
                               #            shadow-box: 1px 1px 1px 1px;
                               #            text-align: left;
                               #            font-size:15px;
                               #            border-style:note;
                               #            '>
                               #            <tr>
                               #            <td>",
                               #                     Diseases_LayTexts[ChronicResultsNames [1]]
                               #                   )
                               #                 ),
                               #                 
                               #                 
                               #                 progressBar(
                               #                   id = "pb1",
                               #                   status = ChronicResultsStatus[1],
                               #                   value = round(ChronicResultsPercents[1])
                               #                 ),
                               #                 HTML("
                               #                    </td>
                               #                     </tr>"),
                               #                 
                               #                 if (!is.na(ChronicResultsNames[2]))
                               #                   HTML(" <tr>    <td>"),
                               #                 if (!is.na(ChronicResultsNames[2]))
                               #                   Diseases_LayTexts[ChronicResultsNames[2]],
                               #                 if (!is.na(ChronicResultsNames[2]))
                               #                   progressBar(
                               #                     id = "pb1",
                               #                     status = ChronicResultsStatus[2],
                               #                     value = round(ChronicResultsPercents[2])
                               #                   ),
                               #                 if (!is.na(ChronicResultsNames[2]))
                               #                   HTML(" </tr>    </td>"),
                               #                 
                               #                 
                               #                 if (!is.na(ChronicResultsNames[3]))
                               #                   HTML(" <tr>    <td>"),
                               #                 if (!is.na(ChronicResultsNames[3]))
                               #                   Diseases_LayTexts[ ChronicResultsNames[3]],
                               #                 if (!is.na(ChronicResultsNames[3]))
                               #                   progressBar(
                               #                     id = "pb1",
                               #                     status = ChronicResultsStatus[3],
                               #                     value = round(ChronicResultsPercents[3])
                               #                   ),
                               #                 if (!is.na(ChronicResultsNames[3]))
                               #                   HTML(" </tr>    </td>"),
                               #                 
                               #                 if (!is.na(ChronicResultsNames[4]))
                               #                   HTML(" <tr>    <td>"),
                               #                 if (!is.na(ChronicResultsNames[4]))
                               #                   Diseases_LayTexts[ChronicResultsNames[4]],
                               #                 if (!is.na(ChronicResultsNames[4]))
                               #                   progressBar(
                               #                     id = "pb1",
                               #                     status = ChronicResultsStatus[4],
                               #                     value = round(ChronicResultsPercents[4])
                               #                   ),
                               #                 if (!is.na(ChronicResultsNames[4]))
                               #                   HTML(" </tr>    </td>"),
                               #                 
                               #                 if (!is.na(ChronicResultsNames[5]))
                               #                   HTML(" <tr>    <td>"),
                               #                 if (!is.na(ChronicResultsNames[5]))
                               #                   Diseases_LayTexts[ChronicResultsNames[5]],
                               #                 if (!is.na(ChronicResultsNames[5]))
                               #                   progressBar(
                               #                     id = "pb1",
                               #                     status = ChronicResultsStatus[5],
                               #                     value = round(ChronicResultsPercents[5])
                               #                   ),
                               #                 if (!is.na(ChronicResultsNames[5]))
                               #                   HTML(" </tr>    </td>"),
                               #                 
                               #                 
                               #                 
                               #                 
                               #                 HTML("
                               # 
                               #               </table>
                               # 
                               #                   ")
                               
                             )
                           ))
                           ,
                           duration = 'faster',
                           delay = 0,
                           steps = 50,
                           iteration = NULL
                           )
                           
                         })
                       }                        
                       
                       
                       # 
                       #                        output$link <- renderUI({
                       #                          fade_in_left(
                       #                            (div(
                       #                            class = "yours messages",
                       #                            div(
                       #                              class = "message",
                       # 
                       # 
                       # 
                       #                             HTML("
                       # 
                       # 
                       # 
                       #                                                  
                       # 
                       #                                                  You can share the following link with your healthcare provider, so he can retrieve all your answers in readable form, and take it from where you finished. Encourage your provider to start from here... <br><br>
                       # 
                       #                                                ")
                       #                                              ,
                       #                                              HTML(
                       # 
                       #                                              paste0(
                       #                                              "<a href='https://endlessmedical.com/patientencounter/?SessionID=",SessionIDCurrent)),
                       # 
                       #                                              HTML(
                       #                                              paste0("' style='color:#000000;' target='_blank' ><p align='left '; style='text-align: left; '>
                       #                                                     endlessmedical.com/patientencounter/?SessionID=",SessionIDCurrent)),HTML("</a><br><br>"
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
                       # )
                       # 
                       # 
                       # 
                       #                            )
                       #                          ))
                       #                          ,
                       #                          duration = 'faster',
                       #                          delay = 0,
                       #                          steps = 50,
                       #                          iteration = NULL
                       #                          )
                       # 
                       #                        })
                       # 
                       # 
                       # 
                       #                        
                       
                       
                     }
                 if (SoFarFeatures > 80)
                   if (length(ResultsStatus) < 1)
                   {
                     output$question <-
                       renderUI({
                         (div(class = "yours messages",
                              div(
                                class = "message last",
                                HTML(
                                  "Hmm... it seems, like I won't be able to help you, as your symptoms combination is not telling me enough. You will need to discuss your symptoms with healthcare provider. If you want to, start from scratch, please refresh the website. Have a great day and thank you!"
                                )
                                ,
                                HTML(
                                  "<img src='logobluetrans.png'  width='20px' style='margin-left: 0px; margin-right: 0px; margin-top: 0px;  align:left; float:left; position: relative;
                                      top: 28px;
                                        left: -48px;
                                                  '>"
                                )
                                
                              )))
                       })
                     shinyjs::hide(id = "answers")#,anim = TRUE, animType = "fade", time = 1)
                     
                     
                   }
               })
  
})
