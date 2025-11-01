<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to Laravel 12</title>
    
    @vite(['resources/scss/app.scss', 'resources/js/app.js'])
</head>
<body class="bg-light">

    <div class="container vh-100 d-flex flex-column justify-content-center align-items-center text-center">
        <div class="card shadow p-5 rounded-4">
            <h1 class="display-5 fw-bold mb-3 text-primary">Welcome to Laravel 12</h1>
            <p class="lead mb-4 text-muted">
                Your Laravel application is ready!  
                Start building something amazing.
            </p>

            <a href="{{ url('/home') }}" class="btn btn-primary px-4">Go to Dashboard</a>
        </div>

        <footer class="mt-5 text-muted">
            <small>&copy; {{ date('Y') }} Laravel 12 • Powered by Bootstrap 5</small>
        </footer>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
