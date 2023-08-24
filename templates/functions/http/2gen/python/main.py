import functions_framework

# Start script
@functions_framework.http
def main(request):
    request_args = request.args

    return 'All done =)'