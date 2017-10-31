from rest_framework import serializers
from .models import Music

class MusicSerializer(serializers.ModelSerializer):
    """Serializer to map the Model instance into JSON format."""

    class Meta:
        """Meta class to map serializer's fields with the model fields."""

        model = Music
        fields = ('id', 'name','rating','photoURLString')
        # read_only_fields = ('rating', 'photoURLString')
    
    # def create(self, request, pk=None, company_pk=None, project_pk=None):
    #     is_many = True if isinstance(request.data, list) else False

    #     serializer = self.get_serializer(data=request.data, many=is_many)
    #     serializer.is_valid(raise_exception=True)
    #     self.perform_create(serializer)
    #     headers = self.get_success_headers(serializer.data)
    #     return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

