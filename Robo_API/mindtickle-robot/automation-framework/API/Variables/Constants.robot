*** Variables ***

### Status Code ###
${badRequestStatusCode}  400
${forbiddenRequestStatusCode}  403
${successRequestStatusCode}  200
${createdRequestStatusCode}  201
${noContentRequestStatusCode}  204
${unAuthorizedRequestStatusCode}  401
${notFoundRequestStatusCode}  404
${serviceUnavailableStatusCode}    503

### JSON FIELDS ####
${categoryField}    category
${photoUrlsField}    photoUrls
${statusField}    status
${emailField}    email
${phoneField}    phone
${userNameField}    username


### JSON Values ####
${statusSold}    sold
${statusAvailable}    Available
${statusPending}    Pending
${photoURL}    http://sampleurl.com
${categoryCat}    Cat
${updatedEmail}    updatedemail@gmail.com
${updatedPhoneNumber}    09998786967