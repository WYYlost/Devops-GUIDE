1.进入虚拟环境

```
apt install python3.11-venv
python3 -m venv myenv
source myenv/bin/activate
```

2.虚拟环境中安装依赖
```
pip install Flask SQLAlchemy
pip list
pip3 install Flask-SQLAlchemy
```

3.启动flask应用
```
python app.py
```

4.测试接口
```
curl -X GET http://127.0.0.1:5000/users
curl -X POST -H "Content-Type: application/json" -d '{"name": "John Doe", "email": "john@example.com"}' http://127.0.0.1:5000/users
curl -X GET http://127.0.0.1:5000/users/1
curl -X PUT -H "Content-Type: application/json" -d '{"name": "Jane Doe", "email": "jane@example.com"}' http://127.0.0.1:5000/users/1
curl -X DELETE http://127.0.0.1:5000/users/1
```


flask的返回
127.0.0.1 - - [12/Mar/2025 17:23:24] "GET /users HTTP/1.1" 200 -
127.0.0.1 - - [12/Mar/2025 17:23:37] "POST /users HTTP/1.1" 201 -
127.0.0.1 - - [12/Mar/2025 17:24:12] "GET /users/1 HTTP/1.1" 200 -
127.0.0.1 - - [12/Mar/2025 17:24:23] "PUT /users/1 HTTP/1.1" 200 -
127.0.0.1 - - [12/Mar/2025 17:24:46] "DELETE /users/1 HTTP/1.1" 204 -
127.0.0.1 - - [12/Mar/2025 17:38:48] "POST /users HTTP/1.1" 201 -


PS：问题：为什么测试的sqlite数据库是空的？sqlite 文件名里面的数据库名称是test.db，但是在当前目录中没有找到这个文件

可能是因为使用了内存的sqlite数据库，具体代码为
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///test.db'  # 使用SQLite数据库