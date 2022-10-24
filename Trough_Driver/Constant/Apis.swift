//
//  Apis.swift
//  Trough_Driver
//
//  Created by Macbook on 24/02/2021.
//

import Foundation

//API MESSAGE
let STRING_SUCCESS = ""
let STRING_UNEXPECTED_ERROR = ""
let TIMEOUT_MESSAGE = "Request Time out"
let ERROR_NO_NETWORK = "Connection lost. Please check your internet connection and try again. "//"Internet connection is currently unavailable."

let BASE_URL = "https://troughapi.azurewebsites.net"
let LOGIN_API = BASE_URL + "/api/Auth/TruckLogin"
let SIGNUP_API = BASE_URL + "/api/FoodTruck/Register"
let GET_EVENTS_LISTING_URL   = BASE_URL + "/api/Event/GetEvents"

let NEW_OR_EDIT_EVENT_URL             = BASE_URL + "/api/Event/AddEditEvent"

let GET_TRUCK_LISTING = BASE_URL + "/api/FoodTruck/GetNearbyTrucks"
let UPDATE_TRUCK_AVAILABILITY = BASE_URL + "/api/FoodTruck/UpdateAvailability"
let UPDATE_TRUCK_Live_Location = BASE_URL + "/api/FoodTruck/UpdateLiveLocation"
let EVENT_GOING_MAYBE_URL             = BASE_URL + "/api/Event/AddRemoveUserInEvent"

let FORGOT_PASSWORD_API = BASE_URL + "/api/Users/ForgotPassword"

let ADD_MENU_API = BASE_URL + "/api/Menu/AddDeal"
let Edit_MENU_API = BASE_URL + "/api/Menu/EditDeal"

let GET_METHOD = "GET"
let POST_METHOD = "POST"

let RESET_PASSWORD_REQUEST = BASE_URL + "/api/Users/ResetPassword"
let UPDATE_USER_PROFILE                = BASE_URL + "/api/Users/UpdateUserProfile"
let USER_DEVICE_TOKEN_URL             = BASE_URL + "/api/Notification/AddUpdateFcmDeviceToken"

let USER_SUCCESS = "Success"
let FAILED_MESSAGE = "Failed Please Try Again!"

let ADD_EDIT_USER_FAVOURITE_LOCATION = BASE_URL + "/api/UsersFavoriteLocation/AddEdit"
let GET_USER_FAVOURITE_LOCATIONS = BASE_URL + "/api/UsersFavoriteLocation/GetAll"
let GET_ALL_USER                      = BASE_URL + "/api/Users/GetAllUsers"
//let UPDATE_TRUCK_INFO = BASE_URL + "/api/FoodTruck/UpdateTruclInfo"
let UPDATE_TRUCK_INFO = BASE_URL + "/api/FoodTruck/UpdateTruckInfo"
let UPDATE_WORK_HOURS = BASE_URL + "/api/FoodTruck/AddEditWorkHours"
//Stripe Apis

let CREATE_STRIPE_CONNECT_ACCOUNT = BASE_URL + "/api/Payments/CreateStripeConnectAccount"

let CREATE_CUSTOMER_STRIPE_URL        = BASE_URL + "/api/Payments/CreateStripeCustomer"

let GET_ALL_PAYMENT_METHOD_URL        = BASE_URL + "/api/Payments/GetPaymentMethods"

let CreateStripeConnectAccount          = BASE_URL + "/api/Payments/CreateStripeConnectAccount"


let GET_ORDER_BY_TRUCK = BASE_URL + "/api/Orders/GetOrdersByTruck"

let GET_PRE_ORDER_BY_TRUCK = BASE_URL + "/api/Orders/GetPreOrdersByTruck"

let COMPLETE_ORDER_BY_TRUCK = BASE_URL + "​/api​/Orders​/OrderComplete"

let GET_PRIVACY_AND_TERMS = BASE_URL + "/api/Privacy/GetPrivacyAndTerms"

let GET_ALL_FRIEND = BASE_URL + "/api/Users/GetAllFriends"

let GET_ALL_FRIEND_REQUEST = BASE_URL + "/api/Users/GetFriendRequestReceived"

let ADD_EDIT_COMMENT_LIKE_URL         = BASE_URL + "/api/Comments/AddEditCommentOrLike"

let  FOOD_CATEGORIES = BASE_URL + "/api/FoodTruckCategoreis/GetAllCategories"

let LIKE_COMMENT = BASE_URL + "/api/Comments/AddCommentLikes"


let GET_INVITATION_LIST = BASE_URL + "/api/Event/InviteTrucks"

let ACCEPT_REJECT_FRIEND_REQUEST = BASE_URL + "/api/Users/AcceptOrRejectFriend"

let ACCEPT_EVENT_INVITATION_FOR_TRUCK = BASE_URL + "/api/Event/AcceptInvitedTrucks"
