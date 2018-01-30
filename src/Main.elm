{-
   - Copyright © 2018, G.Ralph Kuntz, MD.
   -
   - Licensed under the Apache License, Version 2.0(the "License");
   - you may not use this file except in compliance with the License.
   - You may obtain a copy of the License at
   -
   -     http://www.apache.org/licenses/LICENSE-2.0
   -
   - Unless required by applicable law or agreed to in writing, software
   - distributed under the License is distributed on an "AS IS" BASIS,
   - WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   - See the License for the specific language governing permissions and
   - limitations under the License.
-}


module Main exposing (main)

import Html exposing (Html, a, button, div, h5, li, nav, p, span, text, ul)
import Html.Attributes
    exposing
        ( attribute
        , class
        , classList
        , href
        , id
        , style
        , tabindex
        , target
        , type_
        )
import Html.Attributes.Aria exposing (ariaExpanded, ariaHidden, ariaLabel, ariaLabelledby, role)
import Html.Events exposing (onClick)
import Random.Pcg exposing (Seed, initialSeed)


type alias Flags =
    Int


type alias Model =
    { active : Page
    , seed : Seed
    }


type Msg
    = Activate Page


type Page
    = Characters
    | Playbooks


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initialModel (initialSeed flags), Cmd.none )


initialModel : Seed -> Model
initialModel seed =
    { active = Characters
    , seed = seed
    }


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( model_, cmd ) =
            case msg of
                Activate page ->
                    { model | active = page } ! []

        -- _ =
        --     Debug.log "Main msg, update, cmd" ( msg, model_, cmd )
    in
        ( model_, cmd )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    div [ class "align-items-stretch d-flex flex-column justify-content-between" ]
        [ header model ]


header : Model -> Html Msg
header model =
    div []
        [ nav [ class "navbar navbar-expand-lg navbar-dark bg-primary" ]
            [ div [ class "navbar-brand" ] [ text "Heroes" ]
            , button
                [ ariaExpanded "false"
                , ariaLabel "Toggle navigation"
                , attribute "aria-controls" "sidebar"
                , attribute "data-target" "#sidebar"
                , attribute "data-toggle" "collapse"
                , class "navbar-toggler"
                , type_ "button"
                ]
                [ span [ class "navbar-toggler-icon" ] [] ]
            , div [ class "collapse navbar-collapse", id "sidebar" ]
                [ ul [ class "navbar-nav ml-auto" ]
                    [ li
                        [ class "nav-item"
                        , classList [ ( "active", model.active == Characters ) ]
                        ]
                        [ a [ class "nav-link", href "#", onClick (Activate Characters) ]
                            [ text "Characters"
                            , span [ class "sr-only" ] [ text "(current)" ]
                            ]
                        ]
                    , li
                        [ class "nav-item"
                        , classList [ ( "active", model.active == Playbooks ) ]
                        ]
                        [ a [ class "nav-link", href "#", onClick (Activate Playbooks) ]
                            [ text "Playbooks" ]
                        ]
                    , li [ class "nav-item" ]
                        [ a
                            [ attribute "data-target" "#license"
                            , attribute "data-toggle" "modal"
                            , class "nav-link"
                            , href "#"
                            ]
                            [ text "License" ]
                        ]
                    ]
                ]
            ]
        , div
            [ ariaHidden True
            , ariaLabelledby "licenseLabel"
            , class "fade modal"
            , id "license"
            , role "dialog"
            , tabindex -1
            ]
            [ div [ class "modal-dialog modal-dialog-centered modal-lg", role "document" ]
                [ div [ class "modal-content" ]
                    [ div [ class "modal-header" ]
                        [ h5 [ class "modal-title" ] [ text "Apache 2.0 License" ]
                        ]
                    , div [ class "modal-body" ]
                        [ p [] [ text "Copyright 2018, G. Ralph Kuntz, MD" ]
                        , p []
                            [ text """Licensed under the Apache License, Version 2.0
                                (the "License"); you may not use this file except
                                in compliance with the License. You may obtain a
                                copy of the License at""" ]
                        , p [ style [ ( "text-indent", "2em" ) ] ]
                            [ a
                                [ href "http://www.apache.org/licenses/LICENSE-2.0"
                                , target "_blank"
                                ]
                                [ text "http://www.apache.org/licenses/LICENSE-2.0" ]
                            ]
                        , p []
                            [ text """Unless required by applicable law or agreed
                                to in writing, software distributed under the
                                License is disheadertributed on an "AS IS" BASIS,
                                WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
                                either express or implied. See the License for
                                the specific language governing permissions and
                                limitations under the License.""" ]
                        , p [] [ text "Source code available at " ]
                        , p [ style [ ( "text-indent", "2em" ) ] ]
                            [ a
                                [ href "https://github.com/grkuntzmd/characters-for-dw"
                                , target "_blank"
                                ]
                                [ text "https://github.com/grkuntzmd/characters-for-dw" ]
                            ]
                        ]
                    , div [ class "modal-footer" ]
                        [ button
                            [ attribute "data-dismiss" "modal"
                            , class "btn btn-primary"
                            , type_ "button"
                            ]
                            [ text "Close" ]
                        ]
                    ]
                ]
            ]
        ]
