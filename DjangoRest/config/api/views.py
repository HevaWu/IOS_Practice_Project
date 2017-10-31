from django.shortcuts import render

from rest_framework import generics
from .serializers import MusicSerializer
from .models import Music

from rest_framework.response import Response
from rest_framework import status

from django.http import Http404

# Create your views here.
# generics.ListCreateAPIView
class CreateView(generics.ListCreateAPIView):
    """This class defines the create behavior of our test api."""
    """two attrbutes"""
    queryset = Music.objects.all()
    serializer_class = MusicSerializer

    def perform_create(self, serializer):
        """Save the post data when creating a new music."""
        serializer.save()

    def create(self, request, pk=None):
        """POST single object or array objects, use is_many check if this is an array"""
        is_many = True if isinstance(request.data, list) else False

        serializer = self.get_serializer(data=request.data, many=is_many)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

    # def perform_destroy(self, instance):
    #     print("----------------------------------------------------")
    #     print(self)
    #     if instance.name != "" :
    #         instance.delete()
    #     else:
    #         serializer = MusicSerializer(instance, data = sel.request.data)
    #         serializer.is_valid()
    #         serializer.save(checked=False)
    #         serializer.save(name='')
    #         serializer.save(rating='')
    #         serializer.save(photoURLString='')

    # def delete(self, request, pk=None, company_pk=None, project_pk=None):
    #     """Delete single object or array objects, use is_many check if this is an array"""
    #     is_many = True if isinstance(request.data, list) else False

    #     serializer = self.get_serializer(data=request.data, many=is_many)
    #     serializer.is_valid(raise_exception=True)
    #     self.perform_destroy(serializer)
    #     headers = self.get_success_headers(serializer.data)
    #     serializer.save()
        

    #     return Response(serializer.data, status=status.HTTP_204_NO_CONTENT, headers=headers)

    # def delete(self, request, pk=None, format=None):
    #     try:
    #         music = Music.objects.get(pk=pk)
    #         print("----------------------------------------------------")
    #         print(music)
    #     except Music.DoesNotExist:
    #         # return Response(status=status.HTTP_404_NOT_FOUND)
    #         pass

    #     music.delete()
    #     return Response(status=status.HTTP_204_NO_CONTENT)

    # def get_object(self, pk):
    #     try:
    #         # return Music.objects.get(user = self.request.user, pk=pk)
    #         return Music.objects.get(pk=pk)
    #     except Music.DoesNotExist:
    #         raise Http404

    # def delete(self, request, pk=None, format=None):
    #     """Delete single object or all objects"""
    #     music = self.get_object(pk)
    #     music.delete()
    #     return Response(status=status.HTTP_204_NO_CONTENT)


# RetrieveUpdateDestroyAPIView is a generic view that provides GET, PUT, PATCH, DELETE method handles
class DetailsView(generics.RetrieveUpdateDestroyAPIView):
    """This class handles the http GET, PUT and DELETE requests."""
    queryset = Music.objects.all()
    serializer_class = MusicSerializer
    # slug_field = "name"

    # def perform_create(self, serializer):
    #     """Save the post data when creating a new music."""
    #     serializer.save()

