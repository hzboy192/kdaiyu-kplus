# 加解密控制器

加解密控制器


---
## AES加密接口

> BASIC

**Path:** /tools/crypto/aes/encrypt

**Method:** POST

> REQUEST

**Headers:**

| name | value | required | desc |
| ------------ | ------------ | ------------ | ------------ |
| Content-Type | application/json | YES |  |

**Request Body:**

| name | type | desc |
| ------------ | ------------ | ------------ |
|  | string | 待加密文本 |

**Request Demo:**

```json

```



> RESPONSE

**Headers:**

| name | value | required | desc |
| ------------ | ------------ | ------------ | ------------ |
| content-type | application/json;charset=UTF-8 | NO |  |

**Body:**

| name | type | desc |
| ------------ | ------------ | ------------ |
| status | integer |  |
| data | object |  |
| message | string |  |

**Response Demo:**

```json
{
  "status": 0,
  "data": {},
  "message": ""
}
```




---
## AES解密接口

> BASIC

**Path:** /tools/crypto/aes/decrypt

**Method:** POST

> REQUEST

**Headers:**

| name | value | required | desc |
| ------------ | ------------ | ------------ | ------------ |
| Content-Type | application/json | YES |  |

**Request Body:**

| name | type | desc |
| ------------ | ------------ | ------------ |
|  | string | 待解密文本 |

**Request Demo:**

```json

```



> RESPONSE

**Headers:**

| name | value | required | desc |
| ------------ | ------------ | ------------ | ------------ |
| content-type | application/json;charset=UTF-8 | NO |  |

**Body:**

| name | type | desc |
| ------------ | ------------ | ------------ |
| status | integer |  |
| data | object |  |
| message | string |  |

**Response Demo:**

```json
{
  "status": 0,
  "data": {},
  "message": ""
}
```




---
## RSA加密接口

> BASIC

**Path:** /tools/crypto/rsa/encrypt

**Method:** POST

> REQUEST

**Headers:**

| name | value | required | desc |
| ------------ | ------------ | ------------ | ------------ |
| Content-Type | application/json | YES |  |

**Request Body:**

| name | type | desc |
| ------------ | ------------ | ------------ |
|  | string | 待加密文本 |

**Request Demo:**

```json

```



> RESPONSE

**Headers:**

| name | value | required | desc |
| ------------ | ------------ | ------------ | ------------ |
| content-type | application/json;charset=UTF-8 | NO |  |

**Body:**

| name | type | desc |
| ------------ | ------------ | ------------ |
| status | integer |  |
| data | object |  |
| message | string |  |

**Response Demo:**

```json
{
  "status": 0,
  "data": {},
  "message": ""
}
```




---
## RSA解密接口

> BASIC

**Path:** /tools/crypto/rsa/decrypt

**Method:** POST

> REQUEST

**Headers:**

| name | value | required | desc |
| ------------ | ------------ | ------------ | ------------ |
| Content-Type | application/json | YES |  |

**Request Body:**

| name | type | desc |
| ------------ | ------------ | ------------ |
|  | string | 待解密文本 |

**Request Demo:**

```json

```



> RESPONSE

**Headers:**

| name | value | required | desc |
| ------------ | ------------ | ------------ | ------------ |
| content-type | application/json;charset=UTF-8 | NO |  |

**Body:**

| name | type | desc |
| ------------ | ------------ | ------------ |
| status | integer |  |
| data | object |  |
| message | string |  |

**Response Demo:**

```json
{
  "status": 0,
  "data": {},
  "message": ""
}
```



