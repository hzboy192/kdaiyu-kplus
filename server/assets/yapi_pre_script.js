//console.log("*****************************Pre-request*******************************")
// console.log("context", context)
// console.log("global", global)
try{
    var {pathname, storage} = context
    if(pathname=="/api/login"){
        requestHeader.Authorization=""
        storage.setItem("fina-Authorization","")
        console.log("yapi delete Authorization success!")
    } else if(pathname.startsWith("/api/public/")){
        console.log("yapi add audit token success!")
    } else {
        var token = storage.getItem("fina-Authorization")
        if(token){
             //拦截请求，添加token
            requestHeader.Authorization=storage.getItem("fina-Authorization")
        }
    }
} catch(err){
    console.log('yapi request script error!', err)
}


//============================================================================================//
console.log("*******************************Pre-response*****************************")
console.log(context)

var {href, pathname, responseData, responseStatus, storage, utils} = context
var login_url = href.replace(pathname, "/api/login") 
var login_param = {username:'hzboy192',password:'EoKuYgkYsSDSFn5mYFvL5g=='}

if(responseStatus == 401 && pathname != "/api/login"){
    // 版本浏览器会有跨域问题。
    utils.axios.post(login_url, login_param).then(d =>{
        // 登录成功刷新token
        if(d.data && d.data.status === 200){
            storage.setItem("fina-Authorization", d.data.data)
            console.log("yapi refresh Authorization success!")
        }
    })
}

if(responseStatus == 200 && pathname === '/api/login'){
    storage.setItem("fina-Authorization", responseData.data)
}