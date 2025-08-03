# ExpenseFlow - Quick Start Guide

🚀 **Get ExpenseFlow running in under 2 minutes**

## ✅ **Quick Start - No Manual Configuration Needed**

The implementation is designed to run out-of-the-box with Docker Compose:

```bash
cd examples/expenseflow/implementation/
docker-compose up -d
```

## 🔧 **What Happens Automatically**

1. **Database Setup**: PostgreSQL container with pre-configured database and sample data
2. **Backend Build**: FastAPI container builds automatically from source
3. **Frontend Build**: Next.js container builds automatically  
4. **Network Setup**: All services connect on internal Docker network
5. **Health Checks**: Each service waits for dependencies to be ready

## 🌐 **Access Points**

Once running, you can access:
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **API Documentation**: http://localhost:8000/docs
- **Database**: localhost:5432 (if needed)

## 👤 **Default Login Accounts**

The system comes with pre-configured users:
- **Admin**: `admin@expenseflow.com` / `admin123`
- **Manager**: `manager@expenseflow.com` / `manager123`

## 📋 **Prerequisites**

Just make sure you have:
- **Docker** and **Docker Compose** installed
- **Ports available**: 3000, 8000, 5432, 6379, 80

## 🎯 **First Steps After Startup**

1. **Wait for all services** (about 30-60 seconds for first build)
2. **Open browser** to http://localhost:3000
3. **Login** with admin@expenseflow.com / admin123
4. **Explore the dashboard** and create your first expense!

## 🛑 **Stop the Application**

```bash
docker-compose down
```

## 🔧 **Troubleshooting**

### **Ports Already In Use**
```bash
# Check what's using the ports
lsof -i :3000
lsof -i :8000

# Stop conflicting services or change ports in docker-compose.yml
```

### **Build Issues**
```bash
# Force rebuild containers
docker-compose up --build -d

# Clear Docker cache if needed
docker system prune -a
```

### **Check Service Status**
```bash
# View all services
docker-compose ps

# Check logs
docker-compose logs backend
docker-compose logs frontend
```

## 🎉 **That's It!**

No manual configuration, no environment files to create, no builds to run. The AI Agent Team designed this to be completely self-contained and ready to demonstrate a working expense management system immediately.

**Happy expense tracking!** 💰